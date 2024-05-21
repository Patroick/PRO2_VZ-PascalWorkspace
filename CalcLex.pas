UNIT CalcLex;

INTERFACE

  TYPE 
    Symbol = (plusSy, minusSy, mulSy, divSy, numSy, leftParSy, rightParSy,
              noSy, eofSy);
    

  PROCEDURE InitScanner(s: STRING); 
  PROCEDURE NewSy; (* Update sy *)
  VAR 
    sy: Symbol;
    pos: INTEGER;
    numberVal: INTEGER;

IMPLEMENTATION

  CONST
    eofCh = Chr(0);

  VAR 
    input : STRING;
    ch : CHAR;

  PROCEDURE NewCh; FORWARD; 

  PROCEDURE InitScanner(s: STRING);
  BEGIN
    input := s;
    pos := 0;
    NewCh;
  END;

  PROCEDURE NewCh;
  BEGIN
    IF pos < Length(input) THEN BEGIN
      Inc(pos);
      ch := input[pos];
    END ELSE BEGIN
      ch := eofCh;
    END;
  END;

  PROCEDURE NewSy;
  BEGIN
    WHILE (ch = ' ') DO BEGIN
      NewCh;
    END;
    CASE(ch) OF
      '+' : BEGIN sy := plusSy; NewCh; END;
      '-' : BEGIN sy := minusSy; NewCh; END;
      '*' : BEGIN sy := mulSy; NewCh; END;
      '/' : BEGIN sy := divSy; NewCh; END;
      '(' : BEGIN sy := leftParSy; NewCh; END;
      ')' : BEGIN sy := rightParSy; NewCh; END;
      '0'..'9' : BEGIN 
        sy := numSy;
        numberVal := 0;
        WHILE (ch >= '0') AND (ch <= '9') DO BEGIN
          numberVal := numberVal * 10 + Ord(ch) - Ord('0');
          NewCh;
        END;
      END;
      eofCh: BEGIN sy := eofSy; END;
      ELSE BEGIN sy := noSy; NewCh; END;
    END;
  END;

BEGIN

END.