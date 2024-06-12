UNIT MLInteger;

INTERFACE
USES MLObj;
TYPE
  MLInt = ^MLIntObj;
  MLIntObj = OBJECT(MLObjectObj)
                PRIVATE val : INTEGER;
                PUBLIC
                  CONSTRUCTOR Init(v : INTEGER);
                  FUNCTION AsString : STRING; VIRTUAL;
                  FUNCTION IsEqualTo(other: MLObject) : BOOLEAN; VIRTUAL;
                  FUNCTION IsLessThan(other: MLObject) : BOOLEAN; VIRTUAL;
  END;

IMPLEMENTATION

CONSTRUCTOR MLIntObj.Init(v : INTEGER);
BEGIN
  INHERITED Init;
  Register('MLInt', 'MLObject');
  SELF.val := val;
END;  

FUNCTION MLIntObj.AsString : STRING;
VAR s: STRING;
BEGIN
  Str(val, s);
  AsString := s;
END;

FUNCTION MLIntObj.IsEqualTo(other: MLObject) : BOOLEAN;
BEGIN
  IF other^.IsA('MLInt') THEN
    IsEqualTo := SELF.val = MLInt(other)^.val
  ELSE
    IsEqualTo := FALSE;
END;

FUNCTION MLIntObj.IsLessThan(other: MLObject) : BOOLEAN;
BEGIN
  IF other^.IsA('MLInt') THEN
    IsLessThan := SELF.val < MLInt(other)^.val
  ELSE
    IsLessThan := INHERITED IsLessThan(other);
END;

BEGIN
END.