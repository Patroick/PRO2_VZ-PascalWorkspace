UNIT StackADTv2;

INTERFACE
  TYPE 
    Stack = POINTER;

  PROCEDURE Init(VAR s : Stack);
  PROCEDURE Push(VAR s: Stack; val: INTEGER);
  FUNCTION Pop(VAR s: Stack): INTEGER;
  FUNCTION IsEmpty(VAR s: Stack): BOOLEAN;
  PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION
  TYPE
    NodePtr = ^Node;
    Node = RECORD
      val: INTEGER;
      next: NodePtr;
    END;
    ListPtr = NodePtr;
  
  FUNCTION NewNode(val: INTEGER): NodePtr;
    VAR n: NodePtr;
  BEGIN
    New(n);
    n^.val := val;
    n^.next := NIL;
    NewNode := n;
  END;

  PROCEDURE Push(VAR s: Stack; val: INTEGER);
    VAR n: NodePtr;
  BEGIN
    n := NewNode(val);
    n^.next := NodePtr(s);
    s := n;
  END;

  FUNCTION Pop(VAR s: Stack): INTEGER;
    VAR n: NodePtr;
  BEGIN
    IF s = NIL THEN BEGIN
      WriteLn('Error: Stack is empty');
      HALT;
    END;
    n := NodePtr(s);
    Pop := n^.val;
    s := n^.next;
    Dispose(n);
  END;

  FUNCTION IsEmpty(VAR s: Stack): BOOLEAN;
  BEGIN
    IsEmpty := s = NIL;
  END;

  PROCEDURE Init(VAR s: Stack);
  BEGIN
    s := NIL;
  END;

  PROCEDURE DisposeStack(VAR s: Stack);
    VAR n: NodePtr;
  BEGIN
    WHILE NOT(IsEmpty(s)) NIL DO BEGIN
      Pop(s);
    END;
  END;

BEGIN
END.