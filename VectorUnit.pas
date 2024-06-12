UNIT VectorUnit;

INTERFACE
CONST 
  MAX = 100;

TYPE
  v = ARRAY [1..MAX] OF INTEGER;
  VectorPtr = ^Vector;
  Vector = OBJECT 
              PROTECTED
                vP: ^v;
                vSize: INTEGER;
              PUBLIC
                CONSTRUCTOR Init;
                PROCEDURE Add(val: INTEGER); VIRTUAL;
                PROCEDURE InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;
                PROCEDURE GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
                FUNCTION Size: INTEGER;
                PROCEDURE Clear;
                FUNCTION Capacity: INTEGER;
                PROCEDURE DeleteAt(pos: INTEGER; VAR ok: BOOLEAN);
                DESTRUCTOR Done;
  END;
  CardinalStackPtr = ^CardinalStack;
  CardinalStack = OBJECT 
                    PROTECTED
                      v: Vector;
                    PUBLIC
                      CONSTRUCTOR Init;
                      PROCEDURE Push(val: INTEGER; VAR ok: BOOLEAN);
                      PROCEDURE Pop(VAR val: INTEGER; VAR ok: BOOLEAN);
                      FUNCTION IsEmpty: BOOLEAN;
                      DESTRUCTOR Done;
  END;
  EvenQueuePtr = ^EvenQueue;
  EvenQueue = OBJECT 
                PROTECTED
                  v: Vector;
                PUBLIC
                  CONSTRUCTOR Init;
                  PROCEDURE Enqueue(val: INTEGER; VAR ok: BOOLEAN);
                  PROCEDURE Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);
                  FUNCTION IsEmpty: BOOLEAN;
                  DESTRUCTOR Done;
  END;
  NaturalVectorPtr = ^NaturalVector;
  NaturalVector = OBJECT (Vector)
                    PUBLIC
                      PROCEDURE Add(val: INTEGER); VIRTUAL;
                      PROCEDURE InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;
  END;
  PrimeVectorPtr = ^PrimeVector;
  PrimeVector = OBJECT (Vector)
                  PUBLIC
                    PROCEDURE Add(val: INTEGER); VIRTUAL;
                    PROCEDURE InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN); VIRTUAL;
  END;

IMPLEMENTATION

  (* Vector *********************************************)

  CONSTRUCTOR Vector.Init;
  VAR
    i: INTEGER;
  BEGIN
    NEW(vP);
    vSize := 0;
    FOR i := 1 TO MAX DO BEGIN
      vP^[i] := 0;
    END;
  END;

  PROCEDURE Vector.Add(val: INTEGER);
  VAR
    i: INTEGER;
  BEGIN
    i := 1;
    WHILE (i < MAX) AND (vP^[i] <> 0) DO BEGIN
      i := i + 1;
    END;
    IF i > MAX THEN BEGIN
      WriteLn('Vector is full');
    END
    ELSE BEGIN
      vP^[i] := val;
      vSize := vSize + 1;
    END;
  END;

  PROCEDURE Vector.InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN);
  VAR
    i: INTEGER;
  BEGIN
    IF (pos < 1) OR (pos > MAX) THEN BEGIN
      ok := FALSE
    END ELSE BEGIN
      FOR i := MAX - 1 DOWNTO pos DO BEGIN
        vP^[i + 1] := vP^[i];
      END;
      vP^[pos] := val;
      vSize := vSize + 1;
      ok := TRUE;
    END;
  END;

  PROCEDURE Vector.GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF (pos < 1) OR (pos > MAX) THEN BEGIN
      ok := FALSE
    END ELSE  BEGIN
      val := vP^[pos];
      ok := TRUE;
    END;
  END;

  FUNCTION Vector.Size: INTEGER;
  BEGIN
    Size := vSize;
  END;

  PROCEDURE Vector.Clear;
  VAR
    i: INTEGER;
  BEGIN
    vSize := 0;
    FOR i := 1 TO MAX DO BEGIN
      vP^[i] := 0;
    END;
  END;

  FUNCTION Vector.Capacity: INTEGER;
  BEGIN
    Capacity := MAX;
  END;

  PROCEDURE Vector.DeleteAt(pos: INTEGER; VAR ok: BOOLEAN);
  VAR
    i: INTEGER;
  BEGIN
    IF (pos < 1) OR (pos > MAX) THEN BEGIN
      ok := FALSE
    END ELSE BEGIN
      FOR i := pos TO MAX - 1 DO BEGIN
        vP^[i] := vP^[i + 1];
      END;
      vP^[MAX] := 0;
      vSize := vSize - 1;
      ok := TRUE;
    END;
  END;

  DESTRUCTOR Vector.Done;
  BEGIN
    DISPOSE(vP);
  END;

  (* CardinalStack *********************************************)

  CONSTRUCTOR CardinalStack.Init;
  BEGIN
    v.Init;
  END;

  PROCEDURE CardinalStack.Push(val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF val > 0 THEN BEGIN
      v.Add(val);
      ok := TRUE;
    END ELSE BEGIN
      ok := FALSE;
    END;
  END;

  PROCEDURE CardinalStack.Pop(VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF v.Size = 0 THEN BEGIN
      ok := FALSE
    END ELSE BEGIN
      v.GetElementAt(v.Size, val, ok);
      v.DeleteAt(v.Size, ok);
    END;
  END;

  FUNCTION CardinalStack.IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := v.Size = 0;
  END;

  DESTRUCTOR CardinalStack.Done;
  BEGIN
    v.Done;
  END;

  (* EvenQueue *********************************************)

  CONSTRUCTOR EvenQueue.Init;
  BEGIN
    v.Init;
  END;

  PROCEDURE EvenQueue.Enqueue(val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF (val MOD 2) = 0 THEN BEGIN
      v.Add(val);
      ok := TRUE;
    END ELSE BEGIN
      ok := FALSE;
    END;
  END;

  PROCEDURE EvenQueue.Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF v.Size = 0 THEN BEGIN
      ok := FALSE
    END ELSE BEGIN
      v.GetElementAt(1, val, ok);
      v.DeleteAt(1, ok);
    END;
  END;

  FUNCTION EvenQueue.IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := v.Size = 0;
  END;

  DESTRUCTOR EvenQueue.Done;
  BEGIN
    v.Done;
  END;

  (* NaturalVector *********************************************)

  PROCEDURE NaturalVector.Add(val: INTEGER);
  BEGIN
    IF val > 0 THEN BEGIN
      INHERITED Add(val);
    END ELSE BEGIN
      WriteLn('Value must be positive');
    END;
  END;

  PROCEDURE NaturalVector.InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF val > 0 THEN BEGIN
      INHERITED InsertElementAt(pos, val, ok);
    END ELSE BEGIN
      ok := FALSE;
    END;
  END;

  (* PrimeVector *********************************************)

  PROCEDURE PrimeVector.Add(val: INTEGER);
  VAR
    i: INTEGER;
    isPrime: BOOLEAN;
  BEGIN
    i := 2;
    isPrime := TRUE;
    WHILE (i < val) AND isPrime DO BEGIN
      IF (val MOD i) = 0 THEN BEGIN
        isPrime := FALSE;
      END;
      i := i + 1;
    END;
    IF isPrime THEN BEGIN
      INHERITED Add(val);
    END ELSE BEGIN
      WriteLn('Value must be prime');
    END;
  END;

  PROCEDURE PrimeVector.InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN);
  VAR
    i: INTEGER;
    isPrime: BOOLEAN;
  BEGIN
    i := 2;
    isPrime := TRUE;
    WHILE (i < val) AND isPrime DO BEGIN
      IF (val MOD i) = 0 THEN BEGIN
        isPrime := FALSE;
      END;
      i := i + 1;
    END;
    IF isPrime THEN BEGIN
      INHERITED InsertElementAt(pos, val, ok);
    END ELSE BEGIN
      ok := FALSE;
    END;
  END;

BEGIN
END.

