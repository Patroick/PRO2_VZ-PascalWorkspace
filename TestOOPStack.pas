PROGRAM TestOOPStack;

USES ModStack;

VAR s: SafeStackPtr;
VAR i: INTEGER;

BEGIN
  New(s, Init);
  FOR i := 1 TO 30 DO BEGIN
    s^.Push(i);
  END;
  
  WHILE NOT s^.IsEmpty DO BEGIN
    s^.Pop(i);
    WriteLn(i);
  END;
  
  Dispose(s, Done);
END.
