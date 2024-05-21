PROGRAM TestStack;
USES (* StackADS; (* Push(), Pop(), isEmoty for a stack of integer *)
  StackADTv3;

VAR 
  i: INTEGER;
  s1, s2 : Stack;

BEGIN
  Init(s1); Init(s2);
  FOR i := 1 TO 10 DO 
    IF Odd(i) THEN Push(s1, i) ELSE Push(s2, i);

  WHILE NOT IsEmpty(s1) DO 
    WriteLn(Pop(s1));

  WHILE NOT IsEmpty(s2) DO 
    WriteLn(Pop(s2));
  
  DisposeStack(s1); DisposeStack(s2);
END.