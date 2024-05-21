UNIT StackADTv3;

INTERFACE
  TYPE 
    Stack = POINTER;

  PROCEDURE Init(VAR s : Stack);
  PROCEDURE Push(VAR s: Stack; val: INTEGER);
  FUNCTION Pop(VAR s: Stack): INTEGER;
  FUNCTION IsEmpty(VAR s: Stack): BOOLEAN;
  PROCEDURE DisposeStack(VAR s: Stack);

// Implementaion with an Array
IMPLEMENTATION
  TYPE
    IntArray = ARRAY [1..1] OF INTEGER;
    StackRec = RECORD
      len: INTEGER;
      capacity: INTEGER;
      arr: IntArray;
    END;
    StackPtr = ^StackRec;

  PROCEDURE Init(VAR s : Stack);
  CONST initialCapacity = 10;
  VAR sPtr : StackPtr;
  BEGIN
    GetMem(sPtr, (initialCapacity + 2) * SizeOf(INTEGER));
    sPtr^.len := 0;
    sPtr^.capacity := initialCapacity;
    s := sPtr;
  END;

  PROCEDURE AssertInitialized(VAR s: Stack);
  BEGIN
    IF s = NIL THEN BEGIN
      WriteLn('Error: Stack not initialized!');
      HALT;
    END;
  END;

  PROCEDURE Push(VAR s: Stack; val: INTEGER);
  VAR
    sPtr: StackPtr;
  BEGIN
    AssertInitialized(s);
    sPtr := StackPtr(s);
    IF sPtr^.len < sPtr^.capacity THEN BEGIN
      {$R-}
      sPtr^.arr[sPtr^.len + 1] := val;
      {$R+}
      Inc(sPtr^.len);
    END ELSE BEGIN
      WriteLn('Error: Stack is full!');
      HALT;
    END;
  END;

  FUNCTION Pop(VAR s: Stack): INTEGER;
  VAR
    sPtr: StackPtr;
  BEGIN
    AssertInitialized(s);
    sPtr := StackPtr(s);
    IF isEmpty(s) THEN BEGIN
      WriteLn('Error: Stack is empty!');
      HALT;
    END ELSE BEGIN
      {$R-}
      Pop := sPtr^.arr[sPtr^.len];
      {$R+}
      Dec(sPtr^.len);
    END; 
  END;

  FUNCTION IsEmpty(VAR s: Stack): BOOLEAN;
  VAR
    sPtr: StackPtr;
  BEGIN
    AssertInitialized(s);
    sPtr := StackPtr(s);
    IsEmpty := sPtr^.len = 0;
  END;

  PROCEDURE DisposeStack(VAR s: Stack);
  BEGIN
    AssertInitialized(s);
    FreeMem(StackPtr(s), (StackPtr(s)^.capacity + 2) * SizeOf(INTEGER));
    s := NIL;
  END;
  
BEGIN
END.