PROGRAM Calculator;
USES CalcLex, CalcSem;

  VAR 
    input : STRING;

BEGIN
  Write('Expression: ');
  ReadLn(input);
  InitScanner(input);
  InitParser;

  S;
  IF success THEN BEGIN 
    WriteLn('Parsed successfully');
  END ELSE BEGIN
    WriteLn('Syntax error at position ', pos);
  END;
  (*
  REPEAT
    NewSy;
    WriteLn(sy);
  UNTIL sy = eofSy;
  *)

END.