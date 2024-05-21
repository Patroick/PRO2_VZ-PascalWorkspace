(* TestVADS:                                                      PP, 2024-04-24 *)
(* ------                                                                    *)
(* TestVADS                                                                      *)
(* ========================================================================= *)

PROGRAM TestVADS;
  USES 
    VADS;

BEGIN

  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());
  Add(1);
  WriteLn('1 ', ElementAt(1));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Add(2);
  WriteLn('2 ', ElementAt(2));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Add(3);
  WriteLn('3 ', ElementAt(3));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  Add(4);
  WriteLn('4 ', ElementAt(4));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  SetElementAt(1, 5);

  WriteLn('1 ', ElementAt(1));

  RemoveElementAt(1);
  WriteLn('2 ', ElementAt(2));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());

  RemoveElementAt(2);
  WriteLn('2 ', ElementAt(2));
  WriteLn('size ', Size());
  WriteLn('capacity ', Capacity());
END.