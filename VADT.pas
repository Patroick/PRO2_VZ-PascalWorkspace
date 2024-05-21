UNIT VADT;

INTERFACE
  TYPE
    Vector = POINTER;

  PROCEDURE InitVector(VAR v: Vector);
  PROCEDURE Add(VAR v: Vector; val: INTEGER);
  PROCEDURE SetElementAt(VAR v: Vector; pos: INTEGER; val: INTEGER);
  FUNCTION ElementAt(VAR v: Vector; pos: INTEGER): INTEGER;
  PROCEDURE RemoveElementAt(VAR v: Vector; pos: INTEGER);
  FUNCTION Size(VAR v: Vector): INTEGER;
  FUNCTION Capacity(VAR v: Vector): INTEGER;

IMPLEMENTATION

  TYPE
    IntArray = ARRAY [1..1] OF INTEGER;
    VectorRecord = RECORD
      s, c: INTEGER;
      ap: IntArray;
    END;
    PVector = ^VectorRecord;

  PROCEDURE InitVector(VAR v: Vector);
  VAR
    vec: PVector;
  BEGIN
    GetMem(vec, vec^.s + 2 * SizeOf(INTEGER));
    vec^.s := 0;
    vec^.c := 2;
    v := vec;
  END;

  PROCEDURE Add(VAR v: Vector; val: INTEGER);
  VAR
    vec: PVector;
  BEGIN
    vec := v;
    IF vec^.s = vec^.c THEN BEGIN
      vec^.c := vec^.c * 2;
      GetMem(vec, (vec^.c + 2) * SizeOf(INTEGER));
    END;

    {$R-}
    vec^.s := vec^.s + 1;
    vec^.ap[vec^.s] := val;
    {$R+}
    v := vec;
  END;


  PROCEDURE SetElementAt(VAR v: Vector; pos: INTEGER; val: INTEGER);
  VAR
    vec: PVector;
  BEGIN
    vec := v;
    IF (pos < 1) OR (pos > vec^.s) THEN BEGIN
      WriteLn('Index out of bounds');
      Halt;
    END;
    {$R-}
    vec^.ap[pos] := val;
    {$R+}
  END;

  FUNCTION ElementAt(VAR v: Vector; pos: INTEGER): INTEGER;
  VAR
    vec: PVector;
  BEGIN
    vec := v;
    IF (pos < 1) OR (pos > vec^.s) THEN BEGIN
      WriteLn('Index out of bounds');
      Halt;
    END;
    {$R-}
    ElementAt := vec^.ap[pos];
    {$R+}
  END;

  PROCEDURE RemoveElementAt(VAR v: Vector; pos: INTEGER);
  VAR
    vec: PVector;
    i: INTEGER;
  BEGIN
    vec := v;
    IF (pos < 1) OR (pos > vec^.s) THEN BEGIN
      WriteLn('Index out of bounds');
      Halt;
    END;
    vec^.s := vec^.s - 1;
    FOR i := pos TO vec^.s DO BEGIN
      {$R-}
      vec^.ap[i] := vec^.ap[i + 1];
      {$R+}
    END;
  END;

  FUNCTION Size(VAR v: Vector): INTEGER;
  VAR
    vec: PVector;
  BEGIN
    vec := v;
    Size := vec^.s;
  END;

  FUNCTION Capacity(VAR v: Vector): INTEGER;
  VAR
    vec: PVector;
  BEGIN
    vec := v;
    Capacity := vec^.c;
  END;


BEGIN
END.
