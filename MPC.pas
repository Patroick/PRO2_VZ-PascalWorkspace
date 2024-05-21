PROGRAM MPC;
USES MP_Lex, MPC_SS, CodeGen, CodeDef, CodeInt, CodeDis;

VAR input : TEXT;
    inputName : STRING;
    ca: CodeArray;

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
  END;

  Close(input);
END.