(* TestVADT:                                                      PP, 2024-04-26 *)
(* ------                                                                    *)
(* TestVADT                                                                      *)
(* ========================================================================= *)

PROGRAM TestVADT;
  USES 
    VADT;

  VAR
    v1, v2 : Vector;

BEGIN
  InitVector(v1); 
  InitVector(v2);

  WriteLn('v1 size ', Size(v1));
  WriteLn('v1 capacity ', Capacity(v1));
  Add(v1, 1);
  WriteLn('v1 1 ', ElementAt(v1, 1));
  WriteLn('v1 size ', Size(v1));
  WriteLn('v1 capacity ', Capacity(v1));

  WriteLn('v1 size ', Size(v1));
  WriteLn('v1 capacity ', Capacity(v1));
  Add(v1, 2);
  WriteLn('v1 2 ', ElementAt(v1, 2));
  WriteLn('v1 size ', Size(v1));
  WriteLn('v1 capacity ', Capacity(v1));

  Add(v2, 1);
  WriteLn('v2 1 ', ElementAt(v2, 1));
  WriteLn('v2 size ', Size(v2));
  WriteLn('v2 capacity ', Capacity(v2));

  SetElementAt(v1, 1, 5);

  WriteLn('v1 1 ', ElementAt(v1, 1));

  RemoveElementAt(v1, 1);
  WriteLn('v1 1 ', ElementAt(v1, 1));
  WriteLn('v1 size ', Size(v1));
  WriteLn('v1 capacity ', Capacity(v1));


END.