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
              PUBLIC
                CONSTRUCTOR Init;
                PROCEDURE Add(val: INTEGER);
                PROCEDURE InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN);
                PROCEDURE GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
                FUNCTION Size: INTEGER;
                PROCEDURE Clear;
                FUNCTION Capacity: INTEGER;
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
  END;

IMPLEMENTATION

  (* Vector *********************************************)

  CONSTRUCTOR Vector.Init;
  VAR
    i: INTEGER;
  BEGIN
    NEW(vP);
    IF vP = NIL THEN BEGIN
      WriteLn('Memory allocation failed');
      HALT(1);
    END;
    FOR i := 1 TO MAX DO BEGIN
      vP^[i] := 0;
    END;
  END;

  PROCEDURE Vector.Add(val: INTEGER);
  VAR
    i: INTEGER;
  BEGIN
    i := 1;
    WHILE (i <= MAX) AND (vP^[i] <> 0) DO BEGIN
      i := i + 1;
      IF i > MAX THEN BEGIN
        WriteLn('Vector is full')
      END ELSE BEGIN
        vP^[i] := val;
      END;
    END;
  END;

  PROCEDURE Vector.InsertElementAt(pos: INTEGER; val: INTEGER; VAR ok: BOOLEAN);
  VAR
    i: INTEGER;
  BEGIN
    IF (pos < 1) OR (pos > MAX) THEN
      ok := FALSE
    ELSE
      BEGIN
        FOR i := MAX - 1 DOWNTO pos DO BEGIN
          vP^[i + 1] := vP^[i];
        END;
        vP^[pos] := val;
        ok := TRUE;
      END;
  END;

  PROCEDURE Vector.GetElementAt(pos: INTEGER; VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF (pos < 1) OR (pos > MAX) THEN
      ok := FALSE
    ELSE
      BEGIN
        val := vP^[pos];
        ok := TRUE;
      END;
  END;

  FUNCTION Vector.Size: INTEGER;
  VAR
    i: INTEGER;
  BEGIN
    i := 1;
    WHILE (i <= MAX) AND (vP^[i] <> 0) DO
      i := i + 1;
    Size := i - 1;
  END;

  PROCEDURE Vector.Clear;
  VAR
    i: INTEGER;
  BEGIN
    FOR i := 1 TO MAX DO BEGIN
      vP^[i] := 0;
    END;
  END;

  FUNCTION Vector.Capacity: INTEGER;
  BEGIN
    Capacity := MAX;
  END;

  (* CardinalStack *********************************************)

  CONSTRUCTOR CardinalStack.Init;
  BEGIN
    v.Init;
  END;

  PROCEDURE CardinalStack.Push(val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    v.Add(val);
    ok := TRUE;
  END;

  PROCEDURE CardinalStack.Pop(VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF v.Size = 0 THEN
      ok := FALSE
    ELSE
      BEGIN
        v.GetElementAt(v.Size, val, ok);
        v.InsertElementAt(v.Size, 0, ok);
      END;
  END;

  FUNCTION CardinalStack.IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := v.Size = 0;
  END;

  (* EvenQueue *********************************************)

  CONSTRUCTOR EvenQueue.Init;
  BEGIN
    v.Init;
  END;

  PROCEDURE EvenQueue.Enqueue(val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    v.Add(val);
    ok := TRUE;
  END;

  PROCEDURE EvenQueue.Dequeue(VAR val: INTEGER; VAR ok: BOOLEAN);
  BEGIN
    IF v.Size = 0 THEN
      ok := FALSE
    ELSE
      BEGIN
        v.GetElementAt(1, val, ok);
        v.InsertElementAt(1, 0, ok);
      END;
  END;

  FUNCTION EvenQueue.IsEmpty: BOOLEAN;
  BEGIN
    IsEmpty := v.Size = 0;
  END;

BEGIN
END.

