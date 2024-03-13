UNIT ModHashtableChaining;

INTERFACE
PROCEDURE Lookup(key : STRING);
PROCEDURE WriteHashtable;

IMPLEMENTATION

USES ModHashfunctions;

CONST 
  M = 1000;

TYPE 
  NodePtr = ^Node;
  Node = RECORD
    val: STRING;
    next: NodePtr;
  END;
  Hashtable = ARRAY [0..M] OF NodePtr;



PROCEDURE WriteHashtable;
VAR 
  i : INTEGER;
  current : NodePtr;

BEGIN 
  FOR i := Low(ht) TO High(ht) DO BEGIN
    current := ht[i];
    IF current <> NIL THEN Write(i, ': ');
    WHILE current <> NIL DO BEGIN
      Write(' -> ', current^.val);
      current := current^.next;
    END;
    IF ht[i] <> NIL THEN WriteLn;
  END;
END; 

VAR i : INTEGER;

BEGIN 
  (* Init Hashtable *)
  FOR i := Low(ht) TO High(ht) DO
    ht[i] := NIL;

END. 