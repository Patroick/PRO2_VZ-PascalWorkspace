UNIT MP_SS; (* syntax analysator and semantic evaluation for minipascal *)

INTERFACE
VAR 
  success : BOOLEAN;
  PROCEDURE S;

IMPLEMENTATION
USES MP_Lex, SymTab;

PROCEDURE MP; FORWARD;
PROCEDURE VarDecl; FORWARD;
PROCEDURE StatSeq; FORWARD;
PROCEDURE Stat; FORWARD;
PROCEDURE Expr(VAR e : INTEGER); FORWARD;
PROCEDURE Term(VAR t : INTEGER); FORWARD;
PROCEDURE Fact(VAR f : INTEGER); FORWARD;

PROCEDURE SemErr(msg : STRING);
BEGIN
  WriteLn(msg);
  HALT;
END;

PROCEDURE S;
BEGIN
  success := TRUE;
  MP; IF NOT success THEN Exit;

  IF sy <> eofSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
END;

(* MP = "PROGRAM" ident ";"
        [ VarDecl ]
        "BEGIN"
        StatSeq
        "END" "." .
*)
PROCEDURE MP;
BEGIN
  (*SEM*) InitSymbolTable; (*ENDSEM*)
  IF sy <> programSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> semiColonSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy = varSy THEN BEGIN
    VarDecl; IF NOT success THEN Exit; 
  END;
  IF sy <> beginSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  StatSeq; IF NOT success THEN Exit;
  IF sy <> endSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> periodSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
END;

(* VarDecl = "VAR" ident { "," ident }
             ":" "INTEGER" ";" .
*)
PROCEDURE VarDecl;
VAR ok: BOOLEAN;
BEGIN
  IF sy <> varSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
  (* SEM *) DeclVar(identStr, ok); (* ENDSEM *)
  NewSy;
  WHILE sy = commaSy DO BEGIN
    NewSy; (* skip ',' *)
    IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
    (* SEM *)
    DeclVar(identStr, ok);
    IF NOT ok THEN
      SemErr('multiple declaration'); 
    (* ENDSEM *)
    NewSy;
  END;
  IF sy <> colonSy THEN BEGIN success := FALSE; Exit; END;
  NewSy; 
  IF sy <> intSy THEN BEGIN success := FALSE; Exit; END;
  NewSy; 
  IF sy <> semiColonSy THEN BEGIN success := FALSE; Exit; END;
  NewSy; 
END;

(* StatSeq = Stat { ";" Stat } . *)
PROCEDURE StatSeq;
BEGIN
  Stat; IF NOT success THEN Exit;
  WHILE sy = semiColonSy DO BEGIN
    NewSy; (* skip ';' *)
    Stat; IF NOT success THEN Exit;
  END;
END;

(* Stat = [ ident ":=" Expr
          | "READ" "(" ident ")"
          | "WRITE" "(" Expr ")"
          ] . 
*)
PROCEDURE Stat;
VAR destId: STRING;
    e: INTEGER;
BEGIN
  IF (sy = identSy) OR (sy = readSy) OR (sy = writeSy) THEN BEGIN
    CASE sy OF 
      identSy: BEGIN 
                 (* SEM *)
                 destId := identStr;
                 IF NOT IsDecl(destId) THEN
                   SemErr('variable is not declared');
                 (* ENDSEM *)
                 NewSy; (* skip ident *)
                 IF sy <> assignSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
                 Expr(e); IF NOT success THEN Exit;
                 (* SEM *)
                 IF IsDecl(destId) THEN
                   SetVal(destId, e); 
                 (* ENDSEM *)
               END;
      readSy: BEGIN
                NewSy; (* skip read *)
                IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
                NewSy;
                IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
                (* SEM *)
                IF NOT IsDecl(identStr) THEN
                  SemErr('variable is not declared')
                ELSE BEGIN
                  Write(identStr, ' > ');
                  ReadLn(e);
                  SetVal(identStr, e);
                END;
                (* ENDSEM *)
                NewSy;
                IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
                NewSy;
              END;
      writeSy: BEGIN 
                 (* "WRITE" "(" Expr ")" *)
                 NewSy; (* skip write *)
                 IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
                 Expr(e); IF NOT success THEN Exit;
                 (* SEM *)
                 WriteLn(e);
                 (* ENDSEM *)
                 IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
               END;
    END; (* CASE *)
  END; (* IF *)  
END; (* Stat *)


(* Expr = Term { '+' Term | '-' Term } . *)
PROCEDURE Expr(VAR e : INTEGER);
VAR t : INTEGER;
BEGIN
  Term(e); IF NOT success THEN Exit;
  WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
    IF sy = plusSy THEN BEGIN
      NewSy; (* skip + *)
      Term(t); IF NOT success THEN Exit;      
      (* SEM *) e := e + t; (* ENDSEM *)
    END ELSE IF sy = minusSy THEN BEGIN
      NewSy; (* skip - *)
      Term(t); IF NOT success THEN Exit;
      (* SEM *) e := e - t; (* ENDSEM *)
    END; (* IF *)
  END; (* WHILE *)
END; (* Expr *)

(* Term = Fact { '*' Fact | '/' Fact } . *)
PROCEDURE Term(VAR t : INTEGER);
VAR f : INTEGER;
BEGIN
  Fact(t); IF NOT success THEN Exit;
  WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
    IF sy = mulSy THEN BEGIN
      NewSy; (* skip * *)
      Fact(f); IF NOT success THEN Exit;      
      (* SEM *) t := t * f; (* ENDSEM *)
    END ELSE IF sy = divSy THEN BEGIN
      NewSy; (* skip / *)
      Fact(f); IF NOT success THEN Exit;
      (* SEM *)
      IF f = 0 THEN 
        SemErr('Division by zero.')
      ELSE 
        t := t DIV f;
      (* ENDSEM *)
    END; (* IF *)
  END; (* WHILE *)
END; (* Term *)

(* Fact = ident | number | '(' Expr ')' . *)
PROCEDURE Fact(VAR f : INTEGER);
BEGIN
  IF sy = identSy THEN BEGIN
     (* SEM *)
     IF NOT IsDecl(identStr) THEN
       SemErr('variable not declared')
     ELSE
       GetVal(identStr, f); 
     (* ENDSEM *)
     NewSy; (* skip ident *)
  END ELSE IF sy = numberSy THEN BEGIN
     (* SEM *) f := numberVal; (* ENDSEM *)
     NewSy; (* skip number *)
  END ELSE IF sy = leftParSy THEN BEGIN
     IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
     NewSy;
     
     Expr(f); IF NOT success THEN Exit;
     
     IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
     NewSy;
  END ELSE BEGIN
    success := FALSE; 
    Exit;
  END;
END;


BEGIN
END.