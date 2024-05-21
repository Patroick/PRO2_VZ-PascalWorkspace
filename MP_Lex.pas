UNIT MP_Lex;

INTERFACE
  TYPE Symbol = (noSy, eofSy, 
                plusSy, minusSy, mulSy, divSy, 
                leftParSy, rightParSy,
                semicolonSy, colonSy,
                periodSy, AssignSy,
                commaSy, 
                beginSy, endSy, varSy, programSy, intSy,
                readSy, writeSy,
                identSy, numberSy);
  
  PROCEDURE InitScanner(VAR input: TEXT); 
  PROCEDURE NewSy; (* Update sy *)
  VAR 
    sy: Symbol;
    lineNr, pos: INTEGER;
    identStr: STRING;
    numberVal: INTEGER;

IMPLEMENTATION

  CONST tabch = CHR(9);
        eofCh = CHR(0);
  VAR
    input: TEXT;
    ch: CHAR;
    line : STRING;

  PROCEDURE InitScanner(VAR input: TEXT);
  BEGIN
    MP_Lex.input := input;
    lineNr := 0;
    pos := 0;
    line := '';
    ch := ' ';
    NewSy;
  END;

  PROCEDURE NewCh;
  BEGIN
    IF pos < Length(line) THEN BEGIN 
      Inc(pos);
      ch := line[pos];
    END ELSE BEGIN 
      IF NOT EOF(input) THEN BEGIN
        ReadLn(input, line);
        pos := 0;
        Inc(lineNr);
        ch := ' ';
      END ELSE BEGIN
        ch := eofCh;
      END;
    END;
  END;

  PROCEDURE NewSy;
  BEGIN
    WHILE (ch = ' ') OR (ch = tabCH) DO NewCh;
    (* TODO *)

    CASE(ch) OF
      '+' : BEGIN sy := plusSy; NewCh; END;
      '-' : BEGIN sy := minusSy; NewCh; END;
      '*' : BEGIN sy := mulSy; NewCh; END;
      '/' : BEGIN sy := divSy; NewCh; END;
      '(' : BEGIN sy := leftParSy; NewCh; END;
      ')' : BEGIN sy := rightParSy; NewCh; END;
      ';' : BEGIN sy := semicolonSy; NewCh; END;
      '.' : BEGIN sy := periodSy; NewCh; END;
      ',' : BEGIN sy := commaSy; NewCh; END;
      ':' : BEGIN 
              NewCh;
              IF ch = '=' THEN BEGIN
                sy := AssignSy;
                NewCh;
              END ELSE BEGIN
                sy := colonSy;
              END;
            END;
      '_', 'a'..'z', 'A'..'Z' : BEGIN
                                  identStr := '';
                                  WHILE ch IN ['_', 'a'..'z', 'A'..'Z', '0'..'9'] DO BEGIN
                                    identStr := identStr + ch;
                                    NewCh;
                                  END;
                                  identStr := Upcase(identStr);
                                  IF identStr = 'PROGRAM' THEN sy := programSy
                                  ELSE IF identStr = 'VAR' THEN sy := varSy
                                  ELSE IF identStr = 'BEGIN' THEN sy := beginSy
                                  ELSE IF identStr = 'END' THEN sy := endSy
                                  ELSE IF identStr = 'INTEGER' THEN sy := intSy
                                  ELSE IF identStr = 'READ' THEN sy := readSy
                                  ELSE IF identStr = 'WRITE' THEN sy := writeSy
                                  ELSE sy := identSy;   
                                END;
      '0'..'9' : BEGIN 
        numberVal := 0;
        WHILE ch IN ['0'..'9'] DO BEGIN
          numberVal := numberVal * 10 + Ord(ch) - Ord('0');
          NewCh;
        END;
        sy := numberSy;
      END;
      eofCh: BEGIN sy := eofSy; END;
      ELSE BEGIN sy := noSy; NewCh; END;
    END;
  END;

BEGIN

END.