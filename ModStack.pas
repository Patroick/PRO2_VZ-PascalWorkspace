UNIT ModStack;

INTERFACE
CONST max = 10;

TYPE 
  IntArray = ARRAY [1..max] OF INTEGER;
  StackPtr = ^Stack;
  Stack = OBJECT
              PROTECTED 
                data: ^IntArray;
                top: INTEGER;
                capacity: INTEGER;
              PUBLIC
                CONSTRUCTOR Init;
                PROCEDURE Push(val: INTEGER); VIRTUAL;
                PROCEDURE Pop(VAR v: INTEGER); VIRTUAL;
                FUNCTION IsEmpty: BOOLEAN; VIRTUAL;
                DESTRUCTOR Done; VIRTUAL;
  END;

  SafeStackPtr = ^SafeStack;
  SafeStack = OBJECT(Stack)
                PROTECTED
                  PROCEDURE IncreaseCapacity;
                  PROCEDURE DecreaseCapacity;
                  PROCEDURE ChangeCapacity(newCap: INTEGER);
                PUBLIC
                  PROCEDURE Push(val: INTEGER); VIRTUAL;
                  PROCEDURE Pop(VAR v: INTEGER); VIRTUAL;
  END;

IMPLEMENTATION

CONSTRUCTOR Stack.Init;
BEGIN
  top := 0;
  capacity := 10;
  GetMem(data, capacity * SizeOf(INTEGER));
END;

PROCEDURE Stack.Push(val: INTEGER); 
BEGIN
  IF top < capacity THEN BEGIN
    Inc(top);
    {$R-}
    data^[top] := val;
    {$R+}
  END ELSE BEGIN
    WriteLn('Stack is full');
    HALT;
  END;
END;

PROCEDURE Stack.Pop(VAR v: INTEGER);
BEGIN
  IF NOT IsEmpty THEN BEGIN
    {$R-}
    v := data^[top];
    {$R+}
    Dec(top);
  END ELSE BEGIN
    WriteLn('Stack is empty');
    HALT;
  END;
END;

FUNCTION Stack.IsEmpty: BOOLEAN;
BEGIN
  IsEmpty := top = 0;
END;

DESTRUCTOR Stack.Done;
BEGIN
  FreeMem(data, capacity * SizeOf(INTEGER));
END;

(* Safe Stack ------------------------------- *)


PROCEDURE SafeStack.Push(val: INTEGER);
BEGIN
  IF top >= capacity THEN BEGIN
    IncreaseCapacity;
  END;
  INHERITED Push(val);
END;

PROCEDURE SafeStack.Pop(VAR v: INTEGER);
BEGIN
  INHERITED Pop(v);
  IF top <= capacity DIV 3 THEN BEGIN
    DecreaseCapacity;
  END;
END;

PROCEDURE SafeStack.ChangeCapacity(newCap: INTEGER);
VAR 
  newIntArr: ^IntArray;
  i: INTEGER;
BEGIN
  IF top > newCap THEN BEGIN
    WriteLn('Error: ChangeCapacity');
    HALT;
  END;
  WriteLn('Debug: Changing capacity');
  GetMem(newIntArr, newCap * SizeOf(INTEGER));
  FOR i := 1 TO top DO BEGIN
    {$R-}
    NewIntArr^[i] := data^[i];
    {$R+}
  END;
  FreeMem(data, capacity * SizeOf(INTEGER));
  data := NewIntArr;  
  capacity := capacity * 2;
END;


PROCEDURE SafeStack.IncreaseCapacity;
BEGIN
  ChangeCapacity(capacity * 2);
END;

PROCEDURE SafeStack.DecreaseCapacity;
BEGIN
  ChangeCapacity(capacity DIV 2);
END;

BEGIN
END.
