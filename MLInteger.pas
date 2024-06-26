UNIT MLInteger;

INTERFACE
USES MLObj;

TYPE 
  MLInt = ^MLIntObj;
  MLIntObj = OBJECT(MLObjectObj)
               PRIVATE val : INTEGER;
               PUBLIC
                 CONSTRUCTOR Init(val : INTEGER);
                 FUNCTION AsString : STRING; VIRTUAL;
                 FUNCTION IsEqualTo(other : MLObject) : BOOLEAN; VIRTUAL;
                 FUNCTION IsLessThan(other : MLObject) : BOOLEAN; VIRTUAL;
             END;

IMPLEMENTATION

CONSTRUCTOR MLIntObj.Init(val : INTEGER);
BEGIN
  INHERITED Init;
  Register('MLInt', 'MLObject');
  SELF.val := val;
END;

FUNCTION MLIntObj.AsString : STRING;
VAR s : STRING;
BEGIN
  Str(val, s);
  AsString := s;
END;

FUNCTION MLIntObj.IsEqualTo(other : MLObject) : BOOLEAN;
BEGIN
  IF other^.IsA('MLInt') THEN BEGIN
    IsEqualTo := SELF.val = MLInt(other)^.val;
  END ELSE 
    IsEqualTo := FALSE;  
END;

(* a^.IsLessThan(b) *)
FUNCTION MLIntObj.IsLessThan(other : MLObject) : BOOLEAN;
BEGIN
  IF other^.IsA('MLInt') THEN BEGIN
    IsLessThan := SELF.val < MLInt(other)^.val;
  END ELSE 
    IsLessThan := INHERITED IsLessThan(other)
END;

BEGIN
END.