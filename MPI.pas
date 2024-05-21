PROGRAM MPI;
USES MP_Lex, MPI_syn, MP_SS;

VAR input : TEXT;
    inputName : STRING;

BEGIN
  inputName := '';
  IF ParamCount = 1 THEN
    inputName := ParamStr(1);
  
  Assign(input, inputName);
  Reset(input);
  InitScanner(input);

  (* Test the scanner *)
  (* WHILE sy <> eofSy DO BEGIN
    WriteLn(sy);
    NewSy;
  END;
  *)

  S;
  IF success THEN
    WriteLn('Success')
  ELSE
    WriteLn('Syntax error in line ', lineNr, ' at position ', pos);

  Close(input);
END.