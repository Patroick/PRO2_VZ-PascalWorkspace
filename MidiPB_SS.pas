UNIT MidiPB_SS;

INTERFACE

Uses Tree;

VAR 
  success : BOOLEAN;
  t: TreeNode;

  PROCEDURE S;

IMPLEMENTATION
USES MidiP_Lex, SymTab, CodeGen, CodeDef, SysUtils;

PROCEDURE MP; FORWARD;
PROCEDURE VarDecl; FORWARD;
PROCEDURE StatSeq; FORWARD;
PROCEDURE Stat; FORWARD;
FUNCTION Expr: TreeNode; FORWARD;
FUNCTION Term: TreeNode; FORWARD;
FUNCTION Fact: TreeNode; FORWARD;

PROCEDURE SemErr(msg : STRING);
BEGIN
  WriteLn('Semantic error in line ', lineNr, ': ', msg);
  success := FALSE;
END;

PROCEDURE EmitCodeForExprTree(tree: TreeNode);
BEGIN
  IF tree <> nil THEN BEGIN
    EmitCodeForExprTree(tree^.left);
    EmitCodeForExprTree(tree^.right);
    IF tree^.expr = '+' THEN
      Emit1(AddOpc)
    ELSE IF tree^.expr = '-' THEN
      Emit1(SubOpc)
    ELSE IF tree^.expr = '*' THEN
      Emit1(MulOpc)
    ELSE IF tree^.expr = '/' THEN
      Emit1(DivOpc)
    ELSE IF tree^.expr[1] IN ['0'..'9'] THEN
      Emit2(LoadConstOpc, StrToInt(tree^.expr))
    ELSE
      Emit2(LoadValOpc, AddrOf(tree^.expr));
  END;
END;

PROCEDURE OptimizeTree(VAR tree: TreeNode);
BEGIN
  IF tree = NIL THEN Exit;
  OptimizeTree(tree^.left);
  OptimizeTree(tree^.right);
  
  IF (tree^.expr = '+') OR (tree^.expr = '*') THEN BEGIN
    IF (tree^.left^.expr = '0') OR (tree^.right^.expr = '0') THEN BEGIN
      IF tree^.expr = '+' THEN BEGIN
        IF tree^.left^.expr = '0' THEN tree := tree^.right ELSE tree := tree^.left;
      END ELSE IF tree^.expr = '*' THEN BEGIN
        tree^.expr := '0';
        tree^.left := NIL;
        tree^.right := NIL;
      END;
    END ELSE IF (tree^.left^.expr = '1') OR (tree^.right^.expr = '1') THEN BEGIN
      IF tree^.expr = '*' THEN BEGIN
        IF tree^.left^.expr = '1' THEN tree := tree^.right ELSE tree := tree^.left;
      END;
    END;
  END ELSE IF (tree^.expr = '+') AND (tree^.left^.expr[1] IN ['0'..'9']) AND (tree^.right^.expr[1] IN ['0'..'9']) THEN BEGIN
    tree^.expr := IntToStr(StrToInt(tree^.left^.expr) + StrToInt(tree^.right^.expr));
    tree^.left := NIL;
    tree^.right := NIL;
  END;
END;

PROCEDURE S;
BEGIN
  success := TRUE;
  MP; IF NOT success THEN Exit;

  IF sy <> eofSy THEN BEGIN success := FALSE; Exit; END;
  NewSy;

  OptimizeTree(t);
  EmitCodeForExprTree(t);
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
  VAR
    destId: STRING;
    addr, addr1, addr2: INTEGER;
  BEGIN
    IF (sy = identSy) OR (sy = readSy) OR (sy = writeSy) OR (sy = ifSy) OR (sy = whileSy) OR (sy = beginSy) THEN
      BEGIN
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
                    IF sy <> assignSy THEN
                      BEGIN
                        success := FALSE;
                        Exit;
                      END;
                    NewSy;
                    t := Expr;
                    IF NOT success THEN
                      Exit;
                    (* SEM *)
                    IF IsDecl(destId) THEN
                    BEGIN
                      EmitCodeForExprTree(t);
                      Emit1(StoreOpc);
                    END;
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

FUNCTION Expr: TreeNode;
  VAR
    t: TreeNode;
    op: Symbol;
  BEGIN
    t := Term;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      op := sy;
      NewSy;
      t := MakeNode(SymbolToString(op), t, Term);
    END;
    Expr := t;
  END;

FUNCTION Term: TreeNode;
  VAR
    f: TreeNode;
    op: Symbol;
  BEGIN
    f := Fact;
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      op := sy;
      NewSy;
      f := MakeNode(SymbolToString(op), f, Fact);
    END;
    Term := f;
  END;

FUNCTION Fact: TreeNode;
  VAR
    f: TreeNode;
  BEGIN
    IF sy = identSy THEN BEGIN
      f := MakeNode(identStr, nil, nil);
      NewSy;
    END
    ELSE IF sy = numberSy THEN BEGIN
      f := MakeNode(IntToStr(numberVal), nil, nil);
      NewSy;
    END
    ELSE IF sy = leftParSy THEN BEGIN
      NewSy;
      f := Expr;
      IF sy <> rightParSy THEN
        SemErr('Right parenthesis expected')
      ELSE
        NewSy;
    END
    ELSE
      SemErr('Invalid expression');
    Fact := f;
  END;

BEGIN
END.
