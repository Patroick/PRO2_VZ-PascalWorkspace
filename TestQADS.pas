(* TestVADS:                                                  PP, 2024-04-24 *)
(* ------                                                                    *)
(* TestVADS                                                                  *)
(* ========================================================================= *)

PROGRAM TestQADS;
  USES 
    QADS;

BEGIN

  WriteLn('isEmpty ', IsEmpty());
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());
  Enqueue(1);
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Enqueue(2);
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Enqueue(3);
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Enqueue(4);
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());
  WriteLn('isEmpty ', IsEmpty());

  Dequeue();
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Dequeue();
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

END.