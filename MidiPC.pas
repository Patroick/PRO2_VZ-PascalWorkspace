PROGRAM MidiPC;
USES MidiP_Lex, MidiPB_SS, CodeGen, CodeDef, CodeInt, CodeDis, Tree;

VAR input : TEXT;
    inputName : STRING; 
    ca: CodeArray;
    t: TreeNode;

BEGIN
  inputName := '';
  IF ParamCount = 1 THEN
    inputName := ParamStr(1);
  
  Assign(input, inputName);
  Reset(input);
  InitScanner(input);

  S;
  IF NOT success THEN BEGIN
    WriteLn('Syntax error in Line', lineNr, ' at position', pos);
  END ELSE BEGIN
    GetCode(ca);
    StoreCode(inputname + 'c', ca);
    DisassembleCode(ca);
    DisposeTree(t);
  END;

  Close(input);
END.