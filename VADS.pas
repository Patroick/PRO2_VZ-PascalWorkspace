(* VADS:                                                      PP, 2024-04-24 *)
(* ------                                                                    *)
(* VADS                                                                      *)
(* ========================================================================= *)

UNIT VADS;

INTERFACE
  PROCEDURE Add(val: INTEGER);
  PROCEDURE SetElementAt(pos: INTEGER; val: INTEGER);
  FUNCTION ElementAt(pos: INTEGER): INTEGER;
  PROCEDURE RemoveElementAt(pos: INTEGER);
  FUNCTION Size: INTEGER;
  FUNCTION Capacity: INTEGER;

IMPLEMENTATION
  TYPE
    IntArray = ARRAY [1..1] OF INTEGER;
    PIntArray = ^IntArray;

  VAR
    ap: PIntArray;
    s, c: INTEGER;

  PROCEDURE Add(val: INTEGER);
  BEGIN
    IF s = c THEN BEGIN
      c := c * 2;
      GetMem(ap, c * SizeOf(INTEGER));
    END;
    s := s + 1;
    {$R-}
    ap^[s] := val;
    {$R+}
  END;

  PROCEDURE CheckIndex(pos: INTEGER);
    BEGIN
    IF (pos < 1) OR (pos > s) THEN BEGIN
      WriteLn('Index out of bounds');
      Halt;
    END;
  END;

  PROCEDURE SetElementAt(pos: INTEGER; val: INTEGER);
  BEGIN
    CheckIndex(pos);
    {$R-}
    ap^[pos] := val;
    {$R+}
  END;

  FUNCTION ElementAt(pos: INTEGER): INTEGER;
  BEGIN
    CheckIndex(pos);
    {$R-}
    ElementAt := ap^[pos];
    {$R+}
  END;

  PROCEDURE RemoveElementAt(pos: INTEGER);
  VAR
    i: INTEGER;

  BEGIN
    CheckIndex(pos);
    s := s - 1;
    FOR i := pos TO s DO BEGIN
      {$R-}
      ap^[i] := ap^[i + 1];
      {$R+}
    END;
  END;

  FUNCTION Size: INTEGER;
  BEGIN
    Size := s; 
  END;

  FUNCTION Capacity: INTEGER;
  BEGIN
    Capacity := c; 
  END;

BEGIN
 s := 0;
 c := 2;
 GetMem(ap, c * SizeOf(INTEGER));
END.
