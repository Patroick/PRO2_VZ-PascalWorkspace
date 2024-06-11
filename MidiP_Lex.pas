UNIT MidiP_Lex;

INTERFACE 
TYPE Symbol = (noSy, eofSy, 
              plusSy, minusSy, mulSy, divSy,
              leftParSy, rightParSy, 
              semicolonSy, colonSy,
              periodSy, assignSy, 
              commaSy, 
              beginSy, endSy, varSy, programSy, intSy,
              readSy, writeSy,
              ifSy, thenSy, elseSy, whileSy, doSy, 
              identSy, numberSy);
VAR sy : Symbol;
    lineNr, pos : INTEGER;
    identStr : STRING;
    numberVal : INTEGER;

PROCEDURE InitScanner(VAR input : TEXT);
PROCEDURE NewSy;
FUNCTION SymbolToString(sy: Symbol): STRING;

IMPLEMENTATION
CONST tabCh = Chr(9);
      eofCh = Chr(0);

VAR input : TEXT;
    ch : CHAR;
    line : STRING;

PROCEDURE InitScanner(VAR input : TEXT);
BEGIN
  MidiP_Lex.input := input;
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
  WHILE (ch = ' ') OR (ch = tabCh) DO NewCh;
  CASE ch OF
    '+': BEGIN sy := plusSy; NewCh; END;
    '-': BEGIN sy := minusSy; NewCh; END;
    '*': BEGIN sy := mulSy; NewCh; END;
    '/': BEGIN sy := divSy; NewCh; END;
    '(': BEGIN sy := leftParSy; NewCh; END;
    ')': BEGIN sy := rightParSy; NewCh; END;
    ';': BEGIN sy := semiColonSy; NewCh; END;
    '.': BEGIN sy := periodSy; NewCh; END;
    ',': BEGIN sy := commaSy; NewCh; END;
    ':': BEGIN 
           NewCh; 
           IF ch = '=' THEN BEGIN
             sy := assignSy;
             NewCh;
           END ELSE BEGIN
             sy := colonSy;
           END;
         END;
    eofCh: BEGIN sy := eofSy; NewCh; END;
    '_','a'..'z','A'..'Z': BEGIN
                             identStr := '';
                             WHILE ch IN ['_','a'..'z','A'..'Z','0'..'9'] DO BEGIN
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
                             ELSE IF identStr = 'IF' THEN sy := ifSy      
                             ELSE IF identStr = 'THEN' THEN sy := thenSy  
                             ELSE IF identStr = 'ELSE' THEN sy := elseSy  
                             ELSE IF identStr = 'WHILE' THEN sy := whileSy 
                             ELSE IF identStr = 'DO' THEN sy := doSy    
                             ELSE sy := identSy;
                           END;
    '0'..'9': BEGIN
                numberVal := 0;
                WHILE ch IN ['0'..'9'] DO BEGIN
                  numberVal := numberVal * 10 + Ord(ch) - Ord('0');
                  NewCh;
                END;
                sy := numberSy;
              END;
    ELSE BEGIN
           sy := noSy; 
           NewCh;
         END; (* ELSE *)             
  END; (* CASE *)
END;

FUNCTION SymbolToString(sy: Symbol): STRING;
BEGIN
  CASE sy OF
    noSy: SymbolToString := 'noSy';
    eofSy: SymbolToString := 'eofSy';
    plusSy: SymbolToString := '+';
    minusSy: SymbolToString := '-';
    mulSy: SymbolToString := '*';
    divSy: SymbolToString := '/';
    leftParSy: SymbolToString := '(';
    rightParSy: SymbolToString := ')';
    semiColonSy: SymbolToString := ';';
    colonSy: SymbolToString := ':';
    periodSy: SymbolToString := '.';
    assignSy: SymbolToString := ':=';
    commaSy: SymbolToString := ',';
    beginSy: SymbolToString := 'BEGIN';
    endSy: SymbolToString := 'END';
    varSy: SymbolToString := 'VAR';
    programSy: SymbolToString := 'PROGRAM';
    intSy: SymbolToString := 'INTEGER';
    readSy: SymbolToString := 'READ';
    writeSy: SymbolToString := 'WRITE';
    ifSy: SymbolToString := 'IF';
    thenSy: SymbolToString := 'THEN';
    elseSy: SymbolToString := 'ELSE';
    whileSy: SymbolToString := 'WHILE';
    doSy: SymbolToString := 'DO';
    identSy: SymbolToString := 'identifier';
    numberSy: SymbolToString := 'number';
  END; (* CASE *)
END; (* SymbolToString *)


BEGIN
END.
