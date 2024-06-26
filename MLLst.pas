UNIT MLLst;

INTERFACE

USES MLObj, MLColl;

TYPE
  NodePtr = ^Node;
  Node = RECORD
           val: MLObject;
           next: NodePtr;
         END;
  ListPtr = NodePtr;

  MLListIterator = ^MLListIteratorObj;
  MLListIteratorObj = OBJECT
                        PRIVATE
                          n: NodePtr;
                        PUBLIC
                          CONSTRUCTOR Init(n: NodePtr);
                          DESTRUCTOR Done; VIRTUAL;
                          FUNCTION Next: MLObject; VIRTUAL;
  END;

  MLList = ^MLListObj;
  MLListObj = OBJECT(MLObjectObj)
                PRIVATE
                  l: NodePtr;
                PUBLIC
                  CONSTRUCTOR Init;
                  DESTRUCTOR Done; VIRTUAL;
                  PROCEDURE Prepend(val: MLObject);
                  FUNCTION Size: INTEGER; VIRTUAL;
                  PROCEDURE Add(val: MLObject); VIRTUAL;
                  FUNCTION Remove(o: MLObject): MLObject; VIRTUAL;
                  FUNCTION Contains(o: MLObject): BOOLEAN; VIRTUAL;
                  PROCEDURE Clear; VIRTUAL;
                  FUNCTION NewIterator: MLListIterator; VIRTUAL;
  END;

IMPLEMENTATION

CONSTRUCTOR MLListObj.Init;
BEGIN
  INHERITED Init;
  Register('MLList', 'MLObject');
END;

DESTRUCTOR MLListObj.Done;
BEGIN
  Clear;
  INHERITED Done;
END;

PROCEDURE MLListObj.Prepend(val: MLObject);
VAR
  n: NodePtr;
BEGIN
  New(n);
  n^.val := val;
  n^.next := l;
  l := n;
END;

FUNCTION MLListObj.Size: INTEGER;
VAR
  i: INTEGER;
BEGIN
  i := 0;
  WHILE l <> NIL DO BEGIN
    INC(i);
    l := l^.next;
  END;
  Size := i;
END;

PROCEDURE MLListObj.Add(val: MLObject);
BEGIN
  Prepend(val);
END;

FUNCTION MLListObj.Remove(o: MLObject): MLObject;
VAR
  n, prev: NodePtr;
BEGIN
  prev := NIL;
  n := l;
  WHILE (n <> NIL) AND (n^.val <> o) DO BEGIN
    prev := n;
    n := n^.next;
  END;
  IF n <> NIL THEN BEGIN
    IF prev = NIL THEN BEGIN
      Remove := n^.val;
      l := n^.next;
      Dispose(n);
    END ELSE BEGIN
      Remove := n^.val;
      prev^.next := n^.next;
      Dispose(n);
    END;
  END ELSE BEGIN
    Remove := NIL;
  END;
END;

FUNCTION MLListObj.Contains(o: MLObject): BOOLEAN;
VAR
  n: NodePtr;
BEGIN
  n := l;
  WHILE (n <> NIL) AND (n^.val <> o) DO BEGIN
    n := n^.next;
  END;
  Contains := n <> NIL;
END;

PROCEDURE MLListObj.Clear;
BEGIN
  WHILE l <> NIL DO BEGIN
    Remove(l^.val);
  END;
END;

FUNCTION MLListObj.NewIterator: MLListIterator;
VAR
  it: MLListIterator;
BEGIN
  New(it, Init(l));
  NewIterator := it;
END;

CONSTRUCTOR MLListIteratorObj.Init(n: NodePtr);
BEGIN
  SELF.n := n;
END;

FUNCTION MLListIteratorObj.Next: MLObject;
VAR
  o: MLObject;
BEGIN
  IF n <> NIL THEN BEGIN
    o := n^.val;
    n := n^.next;
    Next := o;
  END ELSE BEGIN
    Next := NIL;
  END;
END;

DESTRUCTOR MLListIteratorObj.Done;
BEGIN
END;

BEGIN
END.