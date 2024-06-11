PROGRAM VectorTest;
USES VectorUnit;
VAR
  v: Vector;
  val: INTEGER;
  ok: BOOLEAN;
BEGIN
  v.Init;
  
  v.InsertElementAt(1, 5, ok);
  IF NOT ok THEN
    WriteLn('Test failed: InsertElementAt');
  
  v.GetElementAt(1, val, ok);
  WriteLn('Value at index 1: ', val);

  IF NOT ok OR (val <> 5) THEN
    WriteLn('Test failed: GetElementAt');
  
  WriteLn('Size: ', v.Size);
  WriteLn('Capacity: ', v.Capacity);

  v.Add(6);
  
  v.GetElementAt(1, val, ok);
  WriteLn('Value at index 1: ', val);

  v.GetElementAt(2, val, ok);
  WriteLn('Value at index 2: ', val);

  WriteLn('Size: ', v.Size);

  v.Clear;
  WriteLn('Cleared');
  WriteLn('Size: ', v.Size);
  
END.