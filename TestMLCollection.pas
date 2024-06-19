PROGRAM TestMLCollection;
USES MLObj, MLInteger, MLStr, MLColl, MLVect, MetaInfo;

FUNCTION NewMLInteger(val: INTEGER): MLInt;
VAR i: MLInt;
BEGIN
  New(i, Init(val));
  NewMLInteger := i
END;

PROCEDURE TestCollection;
VAR 
  c : MLCollection;
  o : MLObject;
  it : MLIterator;
  i : MLInt;

BEGIN
  c := NewMLVector();
  c^.Add(NewMLInteger(3));
  c^.Add(NewMLInteger(2));
  c^.Add(NewMLInteger(1));
  c^.WriteAsString;

  it := c^.NewIterator;
  o := it^.Next;
  WHILE o <> NIL DO BEGIN
    WriteLn(o^.AsString);
    o := it^.Next;
  END;
  Dispose(it, Done);

  c^.DisposeElements;
  Dispose(c, Done);
  WriteMetaInfo;
END;

PROCEDURE TestVector;
VAR 
  v : MLVector;
BEGIN
  v := NewMLVector;
  v^.Add(NewMLInteger(3));
  v^.Add(NewMLInteger(2));
  v^.Add(NewMLInteger(1));
  v^.WriteAsString;
  v^.Sort;
  v^.WriteAsString;

  v^.Add(NewMLInteger('Hagenberg'));
  v^.WriteAsString;
  v^.DisposeElements;

  Dispose(v, Done);
  WriteMetaInfo;
END;

BEGIN
  TestCollection;
  TestVector;
END.