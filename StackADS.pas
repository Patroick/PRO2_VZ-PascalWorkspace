UNIT StackADS;

INTERFACE
  PROCEDURE Push(val: INTEGER);
  FUNCTION Pop: INTEGER;
  FUNCTION IsEmpty: BOOLEAN;

IMPLEMENTATION
  TYPE
    NodePtr = ^Node;
    Node = RECORD
      val: INTEGER;
      next: NodePtr;
    END;
    ListPtr = NodePtr;
  
  VAR l : ListPtr;

  FUNCTION NewNode(val: INTEGER): NodePtr;
    VAR n: NodePtr;
  BEGIN
    New(n);
    n^.val := val;
    n^.next := NIL;
    NewNode := n;
  END;

  PROCEDURE Push(val: INTEGER);
    VAR n: NodePtr;
  BEGIN
    n := NewNode(val);
    n^.next := l;
    l := n;
  END;

  FUNCTION Pop: INTEGER;
    VAR n: NodePtr;
  BEGIN
    IF l = NIL THEN BEGIN
      WriteLn('Error: Stack is empty');
      HALT;
    END;
    n := l;
    Pop := l^.val;
    l := l^.next;
    Dispose(n);
  END;

  FUNCTION IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := l = NIL;
  END;

BEGIN
  l := NIL;
END.