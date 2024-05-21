UNIT MPC_SS;

INTERFACE
VAR
  success: BOOLEAN;

  PROCEDURE S;

IMPLEMENTATION
USES MP_Lex, SymTab, CodeGen, CodeDef;

  PROCEDURE MP; FORWARD;
  PROCEDURE VarDecl; FORWARD;
  PROCEDURE StatSeq; FORWARD;
  PROCEDURE Stat; FORWARD;
  PROCEDURE Expr; FORWARD;
  PROCEDURE Term; FORWARD;
  PROCEDURE Fact; FORWARD;

  PROCEDURE SemErr(msg: STRING);
  BEGIN
    WriteLn('Semantic error in line ', lineNr, ': ', msg);
    success := FALSE;
  END;

  PROCEDURE S;
  BEGIN
    success := TRUE;
    MP; IF NOT success THEN EXIT;

    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
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
    (* SEM *)
    InitSymbolTable;
    InitCodeGenerator;
    (* ENDSEM *)
    IF sy <> programSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> semicolonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy = varSy THEN BEGIN
      VarDecl; IF NOT success THEN EXIT;
    END;

    IF sy <> beginSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    StatSeq; IF NOT success THEN EXIT;

    (* SEM *)
    Emit1(EndOpc);
    (* ENDSEM *)
    IF sy <> endSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> periodSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  (*  VarDecl = "VAR" ident { "," ident }
                ":" "INTEGER" ";" .
  *)
  PROCEDURE VarDecl;
    VAR
      ok: BOOLEAN;
  BEGIN
    IF sy <> varSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
    (* SEM *)
    DeclVar(identStr, ok);
    (* ENDSEM *)
    NewSy;

    WHILE sy = commaSy DO BEGIN
      NewSy; (* skip ',' *)
      IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
      (* SEM *)
      DeclVar(identStr, ok);
      IF NOT ok THEN
        SemErr('Muliple declaration of variable ' + identStr);
      (* ENDSEM *)
      NewSy;
    END;

    IF sy <> colonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> intSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> semicolonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  (* StatSeq = Stat { ";" Stat } . *)
  PROCEDURE StatSeq;
  BEGIN
    Stat; IF NOT success THEN EXIT;
    WHILE sy = semicolonSy DO BEGIN
      NewSy; (* skip ';' *)
      Stat; IF NOT success THEN EXIT;
    END;
  END;

  (* Stat = [ ident ":=" Expr
            | "READ" "(" ident ")"
            | "WRITE" "(" Expr ")"
            ] .
  *)
  PROCEDURE Stat;
    VAR
      destId : STRING;
  BEGIN
    IF (sy = identSy) OR (sy = readSy) OR (sy = writeSy) THEN BEGIN
      CASE sy OF
        identSy: BEGIN
                    (* SEM *)
                    destId := identStr;
                    IF NOT IsDecl(destId) THEN
                      SemErr('Variable ' + destId + ' is not declared.')
                    ELSE
                      Emit2(LoadAddrOpc, AddrOf(destId));
                    (* ENDSEM *)
                    NewSy; (* skip ident *)
                    IF sy <> assignSy THEN BEGIN success := FALSE; EXIT; END;
                    NewSy;
                    Expr; IF NOT success THEN EXIT;
                    (* SEM *)
                    IF IsDecl(destId) THEN
                      Emit1(StoreOpc);
                    (* ENDSEM *)
                  END;
        readSy: BEGIN
                  NewSy; (* skip read *)
                  IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;

                  IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
                  (* SEM *)
                  IF NOT IsDecl(identStr) THEN
                    SemErr('Variable ' + identStr + ' is not declared')
                  ELSE
                    Emit2(ReadOpc, AddrOf(identStr));
                  (* ENDSEM *)
                  NewSy;

                  IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                END;
        writeSy:  BEGIN
                    NewSy; (* skip read *)
                    IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
                    NewSy;

                    Expr; IF NOT success THEN EXIT;
                    (* SEM *)
                    Emit1(WriteOpc);
                    (* ENDSEM *)

                    IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
                    NewSy;
                  END;
      END;
    END;
  END;

  (* Expr = Term { '+' Term | '-' Term } . *)
  PROCEDURE Expr;
  BEGIN
    Term; IF NOT success THEN EXIT;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      (* '+' Term | '-' Term *)
      IF sy = plusSy THEN BEGIN
        NewSy; (* skip + *)
        Term; IF NOT success THEN EXIT;
        (* SEM *)
        Emit1(AddOpc);
        (* ENDSEM *)
      END ELSE IF sy = minusSy THEN BEGIN
        NewSy; (* skip - *)
        Term; IF NOT success THEN EXIT;
        (* SEM *)
        Emit1(SubOpc);
        (* ENDSEM *)
      END;
    END;
  END;

  (* Term = Fact { '*' Fact | '/' Fact } . *)
  PROCEDURE Term;
  BEGIN
    Fact; IF NOT success THEN EXIT;
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      (* '*' Fact | '/' Fact *)
      IF sy = mulSy THEN BEGIN
        NewSy; (* skip * *)
        Fact; IF NOT success THEN EXIT;
        (* SEM *)
        Emit1(MulOpc);
        (* ENDSEM *)
      END ELSE IF sy = divSy THEN BEGIN
        NewSy; (* skip / *)
        Fact; IF NOT success THEN EXIT;
        (* SEM *)
        Emit1(DivOpc);
        (* ENDSEM *)
      END;
    END;
  END;

  (* Fact = ident | number | '(' Expr ')' . *)
  PROCEDURE Fact;
  BEGIN
    IF sy = identSy THEN BEGIN
      (* SEM *)
      IF NOT IsDecl(identStr) THEN
        SemErr('Variable ' + identStr + ' is not declared.')
      ELSE
        Emit2(LoadValOpc, AddrOf(identStr));
      (* ENDSEM *)
      NewSy; (* skip ident *)
    END ELSE IF sy = numberSy THEN BEGIN
      (* SEM *)
      Emit2(LoadConstOpc, numberVal);
      (* ENDSEM *)
      NewSy; (* skip number *)
    END ELSE IF sy = leftParSy THEN BEGIN
      IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;

      Expr; IF NOT success THEN EXIT;

      IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE BEGIN
      success := FALSE;
      Exit;
    END;
  END;

BEGIN

END.