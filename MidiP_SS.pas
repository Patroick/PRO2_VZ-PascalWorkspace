UNIT MidiP_SS;

INTERFACE
VAR 
  success : BOOLEAN;
  PROCEDURE S;

IMPLEMENTATION
USES MidiP_Lex, SymTab, CodeGen, CodeDef;

PROCEDURE MP; FORWARD;
PROCEDURE VarDecl; FORWARD;
PROCEDURE StatSeq; FORWARD;
PROCEDURE Stat; FORWARD;
PROCEDURE Expr; FORWARD;
PROCEDURE Term; FORWARD;
PROCEDURE Fact; FORWARD;

PROCEDURE SemErr(msg : STRING);
BEGIN
  WriteLn('Semantic error in line ', lineNr, ': ', msg);
  success := FALSE;
END;

PROCEDURE S;
BEGIN
  success := TRUE;
  MP; IF NOT success THEN Exit;

  IF sy <> eofSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
END;

PROCEDURE MP;
BEGIN
  (* SEM *)
  InitSymbolTable;
  InitCodeGenerator;
  (* ENDSEM *)
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
  (* SEM *)
  Emit1(EndOpc);
  (* ENDSEM *)
  IF sy <> endSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> periodSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
END;

PROCEDURE VarDecl;
VAR ok : BOOLEAN;
BEGIN
  IF sy <> varSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;
  IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
  (* SEM *)
  DeclVar(identStr, ok);
  (* ENDSEM *)
  NewSy;
  WHILE sy = commaSy DO BEGIN
    NewSy;
    IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
    (* SEM *)
    DeclVar(identStr, ok);
    IF NOT ok THEN 
      SemErr('Multiple declaration of variable ' + identStr);
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

PROCEDURE StatSeq;
BEGIN
  Stat; IF NOT success THEN Exit;
  WHILE sy = semiColonSy DO BEGIN
    NewSy;
    Stat; IF NOT success THEN Exit;
  END;
END;

PROCEDURE Stat;
VAR destId: STRING;
    addr, addr1, addr2: INTEGER;
BEGIN
  IF (sy = identSy) OR (sy = readSy) OR (sy = writeSy) OR (sy = ifSy) OR (sy = whileSy) OR (sy = beginSy) THEN BEGIN
    CASE sy OF 
      identSy: BEGIN 
                 (* SEM *)
                 destId := identStr;
                 IF NOT IsDecl(destId) THEN 
                   SemErr('Variable ' + destId + ' is not declared.')
                 ELSE
                   Emit2(LoadAddrOpc, AddrOf(destId));
                 (* ENDSEM *)
                 NewSy;
                 IF sy <> assignSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
                 Expr; IF NOT success THEN Exit;
                 (* SEM *)
                 IF IsDecl(destId) THEN 
                   Emit1(StoreOpc);
                 (* ENDSEM *)
               END;
      readSy: BEGIN
                NewSy;
                IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
                NewSy;
                IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
                (* SEM *)
                IF NOT IsDecl(identStr) THEN
                  SemErr('Variable ' + identStr + ' is not declared.')
                ELSE
                  Emit2(ReadOpc, AddrOf(identStr));
                (* ENDSEM *)
                NewSy;
                IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
                NewSy;
              END;
      writeSy: BEGIN 
                 NewSy; 
                 IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
                 Expr; IF NOT success THEN Exit;
                 (* SEM *)
                 Emit1(WriteOpc);
                 (* ENDSEM *)
                 IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
               END;
      beginSy: BEGIN 
                 NewSy; 
                 StatSeq; IF NOT success THEN Exit;
                 IF sy <> endSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy; 
               END;
      ifSy: BEGIN 
              NewSy; 
              IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
              (* SEM *)
              IF NOT IsDecl(identStr) THEN BEGIN
                SemErr('variable not declared');
              END; (*IF*)
              Emit2(LoadValOpc, AddrOf(identStr));
              Emit2(JmpZOpc, 0); 
              addr := CurAddr - 2; 
              (* ENDSEM *)
              NewSy; 
              IF sy <> thenSy THEN BEGIN success := FALSE; Exit; END;
              NewSy;
              Stat; IF NOT success THEN Exit;
              IF sy = elseSy THEN BEGIN
                (* SEM *)
                Emit2(JmpOpc, 0); 
                FixUp(addr, CurAddr);
                addr := CurAddr - 2; 
                (* ENDSEM *)
                NewSy; 
                Stat; IF NOT success THEN Exit;
              END;
              (* SEM *)
              FixUp(addr, CurAddr);
              (* ENDSEM *)
            END; (* IF *)
      whileSy: BEGIN
                 NewSy; 
                 IF sy <> identSy THEN BEGIN success := FALSE; Exit; END;
                 (* SEM *)
                 IF NOT IsDecl(identStr) THEN BEGIN
                   SemErr('variable not declared');
                   END; (*IF*)
                   addr1 := CurAddr;
                   Emit2(LoadValOpc, AddrOf(identStr));
                   Emit2(JmpZOpc, 0);
                   addr2 := CurAddr - 2; 
                 (* ENDSEM *)
                 NewSy;
                 IF sy <> doSy THEN BEGIN success := FALSE; Exit; END;
                 NewSy;
                 Stat; IF NOT success THEN Exit;
                 (* SEM *)
                 Emit2(JmpOpc, addr1);
                 FixUp(addr2, CurAddr);
                 (* ENDSEM *)
               END; (* WHILE *)
    END; (* CASE *)
  END; (* IF *)  
END; (* Stat *)


PROCEDURE Expr;
BEGIN
  Term; IF NOT success THEN Exit;
  WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
    IF sy = plusSy THEN BEGIN
      NewSy; 
      Term; IF NOT success THEN Exit; 
      (* SEM *)     
      Emit1(AddOpc);
      (* ENDSEM *)
    END ELSE IF sy = minusSy THEN BEGIN
      NewSy; 
      Term; IF NOT success THEN Exit;
      (* SEM *)     
      Emit1(SubOpc);
      (* ENDSEM *)
    END; (* IF *)
  END; (* WHILE *)
END; (* Expr *)

PROCEDURE Term;
BEGIN
  Fact; IF NOT success THEN Exit;
  WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
    IF sy = mulSy THEN BEGIN
      NewSy; 
      Fact; IF NOT success THEN Exit;
      (* SEM *)      
      Emit1(MulOpc);
      (* ENDSEM *)
    END ELSE IF sy = divSy THEN BEGIN
      NewSy; 
      Fact; IF NOT success THEN Exit;
      (* SEM *)
      Emit1(DivOpc);
      (* ENDSEM *)
    END; (* IF *)
  END; (* WHILE *)
END; (* Term *)

PROCEDURE Fact;
BEGIN
  IF sy = identSy THEN BEGIN
     (* SEM *)
     IF NOT IsDecl(identStr) THEN
       SemErr('Variable ' + identStr + ' is not declared.')
     ELSE
       Emit2(LoadValOpc, AddrOf(identStr));
     (* ENDSEM *)
     NewSy; 
  END ELSE IF sy = numberSy THEN BEGIN
     (* SEM *)
     Emit2(LoadConstOpc, numberVal);
     (* ENDSEM *)
     NewSy;
  END ELSE IF sy = leftParSy THEN BEGIN
     IF sy <> leftParSy THEN BEGIN success := FALSE; Exit; END;
     NewSy;
     
     Expr; IF NOT success THEN Exit;
     
     IF sy <> rightParSy THEN BEGIN success := FALSE; Exit; END;
     NewSy;
  END ELSE BEGIN
    success := FALSE; 
    Exit;
  END;
END;


BEGIN
END.
