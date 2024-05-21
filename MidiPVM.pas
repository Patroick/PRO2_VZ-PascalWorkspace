PROGRAM MPVM;
USES CodeDef, CodeInt;

VAR 
  inputName : STRING;
  ca: CodeArray;
  ok: BOOLEAN;

BEGIN
  inputName := '';
  IF ParamCount = 1 THEN
    inputName := ParamStr(1);
  
  LoadCode(inputName, ca, ok);
  IF ok THEN BEGIN
    InterpretCode(ca);
  END ELSE BEGIN
    WriteLn('Error loading code');
  END;
END.