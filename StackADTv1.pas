UNIT StackADTv1;

INTERFACE
  TYPE 
    NodePtr = ^Node;
    Node = RECORD
      val: INTEGER;
      next: NodePtr;
    END;
    ListPtr = NodePtr;
    Stack = ListPtr;

  PROCEDURE Init(VAR s : Stack);
  PROCEDURE Push(VAR s: Stack; val: INTEGER);
  FUNCTION Pop(VAR s: Stack): INTEGER;
  FUNCTION IsEmpty(VAR s: Stack): BOOLEAN;
  PROCEDURE DisposeStack(VAR s: Stack);

IMPLEMENTATION
  
  
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
    n^.next := s;
    s := n;
  END;

  FUNCTION Pop(VAR s: Stack): INTEGER;
    VAR n: NodePtr;
  BEGIN
    IF s = NIL THEN BEGIN
      WriteLn('Error: Stack is empty');
      HALT;
    END;
    n := s;
    Pop := s^.val;
    s := s^.next;
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

BEGIN
END.