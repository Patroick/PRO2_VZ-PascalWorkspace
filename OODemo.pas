PROGRAM OODemo;

TYPE
  AClass = OBJECT
            x: INTEGER;
            CONSTRUCTOR Init(x: INTEGER);
            PROCEDURE M1; VIRTUAL;
          END;
  BClass = OBJECT(AClass)
            y: INTEGER; (* x is inherited *)
            CONSTRUCTOR Init(x: INTEGER; y: INTEGER);
            PROCEDURE M2; (* M1 is inherited *)
            PROCEDURE M1; VIRTUAL;
          END;
  APtr = ^AClass;
  BPtr = ^BClass;

(* Implementation of Classes *)
CONSTRUCTOR AClass.Init(x: INTEGER);
BEGIN
  Self.x := x;
END;

PROCEDURE AClass.M1;
BEGIN
  Writeln('AClass.M1 x = ', x);
END;  

CONSTRUCTOR BClass.Init(x: INTEGER; y: INTEGER);
BEGIN
  INHERITED Init(x);
  Self.y := y;
END;  

PROCEDURE BClass.M1;
BEGIN
  WriteLn('BClass.M1 y= ', y, ' x= ', x);
END;

PROCEDURE BClass.M2;
BEGIN
  WriteLn('BClass.M2 y = ', y, ', x = ', x);
END;


VAR
  aStat: AClass;
  bStat: BClass;
  a1, a2: APtr;
  b: BPtr;

BEGIN
  New(a1, Init(1));
  New(a2, Init(2));
  New(b, Init(1, 2));

  a1^.M1;
  a2^.M1;
  b^.M1;
  b^.M2;

  Dispose(a1);

  a1 := b; (* Test dynamic / virtual methods *)
  a1^.M1;

  Dispose(a2);
  Dispose(b);

  aStat.Init(1);
  bStat.Init(1, 2);

  WriteLn('Calling methods for static objects');
  aStat.M1;
  bStat.M1;
  bStat.M2; 

  WriteLn('@astat = ', LONGINT(@aStat));
  WriteLn('@bstat = ', LONGINT(@bStat));

  aStat := bStat;
  aStat.M1;
END.

