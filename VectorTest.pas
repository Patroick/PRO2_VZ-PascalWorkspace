PROGRAM VectorTest;
USES VectorUnit;
VAR
  v: Vector;
  s: CardinalStack;
  q: EvenQueue;
  n: NaturalVector;
  p: PrimeVector;
  val: INTEGER;
  ok: BOOLEAN;
BEGIN

  (* Vector *******************************************)

  WriteLn('VECTOR TEST');

  v.Init;
  
  v.InsertElementAt(1, 5, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: InsertElementAt');
  END;
  
  v.GetElementAt(1, val, ok);
  WriteLn('Value at index 1: ', val);

  IF NOT ok OR (val <> 5) THEN BEGIN 
    WriteLn('Test failed: GetElementAt');
  END;
  
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
  v.Done;

  (* CardinalStack *******************************************)

  WriteLn;
  WriteLn('CARDINALSTACK TEST');

  s.Init;
  WriteLn('Empty: ', s.IsEmpty);

  s.Push(1, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: Push');
  s.Push(2, ok);
  END; 
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: Push');
  s.Push(3, ok);
  END;
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: Push');
  s.Pop(val, ok);
  END;
  IF NOT ok OR (val <> 3) THEN BEGIN
    WriteLn('Test failed: Pop');
  END;

  WriteLn('Popped: ', val);
  WriteLn('Empty: ', s.IsEmpty);
  s.Done;

  (* EvenQueue *******************************************)

  WriteLn;
  WriteLn('EVENQUEUE TEST');

  q.Init;
  WriteLn('Empty: ', q.IsEmpty);

  q.Enqueue(2, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: Enqueue');
  END;
  q.Enqueue(4, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: Enqueue');
  END;
  q.Enqueue(5, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test passed: Enqueue, Value not even');
  END;
  q.Dequeue(val, ok);
  IF NOT ok OR (val <> 2) THEN BEGIN
    WriteLn('Test failed: Dequeue');
  END;

  WriteLn('Dequeued: ', val);
  WriteLn('Empty: ', q.IsEmpty);
  q.Done;
  WriteLn;

  (* NaturalVector ****************************************)
  
  WriteLn;
  WriteLn('NATURALVECTOR TEST');
  n.Init;

  n.Add(1);
  n.Add(2);
  (* Hier wird Polymorphismus verwendet da die Add Methode
  überschrieben wird, jedoch gleich verwendet wird, das ist 
  auch der Grund dafür warum es notwendig ist *)
  n.Add(-1);
  IF NOT ok THEN BEGIN
    WriteLn('Test passed: Add, Value not natural');
  END;

  (* Hier wieder das selbe *)
  n.InsertElementAt(1, 3, ok);

  IF NOT ok THEN BEGIN
    WriteLn('Test failed: InsertElementAt');
  END;

  n.GetElementAt(1, val, ok);
  WriteLn('Value at index 1: ', val);
  n.InsertElementAt(2, -2, ok);

  IF NOT ok THEN BEGIN
    WriteLn('Test passed: InsertElementAt, Value not natural');
  END;

  n.Done;

  (* PrimeVector ****************************************)

  WriteLn;
  WriteLn('PRIMEVECTOR TEST');
  p.Init;

  (* Hier ebenfalls wieder gleich wie bei NaturalVector*)
  p.Add(1);
  p.Add(2);
  p.Add(6);
  
  p.InsertElementAt(1, 5, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test failed: InsertElementAt');
  END;

  p.GetElementAt(1, val, ok);
  WriteLn('Value at index 1: ', val);

  p.InsertElementAt(2, 6, ok);
  IF NOT ok THEN BEGIN
    WriteLn('Test passed: InsertElementAt, Value not prime');
  END;

  p.Done;
  WriteLn;
END.