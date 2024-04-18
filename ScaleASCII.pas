(* ScaleASCII:                                                PP, 2024-04-17 *)
(* ------                                                                    *)
(* ScaleASCII                                                                *)
(* ========================================================================= *)

PROGRAM ScaleASCII;

USES SysUtils;

  VAR
    scaleX, scaleY: INTEGER;

PROCEDURE ScaleLine(line: STRING; factorX: INTEGER; VAR result: STRING);

  VAR
    i, j: INTEGER;
    charToScale: CHAR;

  BEGIN
    result := ''; 
    IF factorX > 0 THEN BEGIN
      FOR i := 1 TO Length(line) DO BEGIN
        charToScale := line[i];
        FOR j := 1 TO factorX DO BEGIN
          result := result + charToScale;
        END;
      END;
    END ELSE IF factorX < 0 THEN BEGIN
      i := 1;
      WHILE i <= Length(line) DO BEGIN
        result := result + line[i];
        i := i + Abs(factorX); 
      END;
    END ELSE BEGIN
      result := line;
    END;
  END;


PROCEDURE Scale(inFileName, outFileName: STRING; factorX, factorY: INTEGER);

  VAR
    inFile, outFile: TEXT;
    inputLine, outputLine: STRING;
    i: INTEGER;
    lineNumber: INTEGER;

  BEGIN
    Assign(inFile, inFileName);
    Reset(inFile);
    Assign(outFile, outFileName);
    Rewrite(outFile);
    lineNumber := 0; 

    WHILE NOT Eof(inFile) DO BEGIN
      ReadLn(inFile, inputLine);
      ScaleLine(inputLine, factorX, outputLine);
      Inc(lineNumber);
      
      IF factorY > 0 THEN BEGIN
        FOR i := 1 TO factorY DO BEGIN
          WriteLn(outFile, outputLine);
        END;
      END ELSE BEGIN
        IF (lineNumber MOD Abs(factorY)) = 1 THEN BEGIN
          WriteLn(outFile, outputLine);
        END;
      END;
    END;
    Close(inFile);
    Close(outFile);
  END;

FUNCTION IsValidScaleFactor(factor: INTEGER): BOOLEAN;
  BEGIN
    IsValidScaleFactor := (factor >= 2) AND (factor <= 9) OR (factor <= -2) AND (factor >= -9);
  END;

BEGIN

  scaleX := 1;
  scaleY := 1; 

  IF (ParamCount = 6)  THEN BEGIN
    scaleX := StrToInt(ParamStr(2));
    scaleY := StrToInt(ParamStr(4));
    IF IsValidScaleFactor(scaleX) AND IsValidScaleFactor(scaleY) THEN BEGIN
      Scale(ParamStr(5), ParamStr(6), scaleX, scaleY);
    END ELSE BEGIN
      WriteLn('Invalid scale factor. Please ensure scale factors are between -9 and -2 or 2 and 9.');
    END;
  END ElSE IF (ParamCount = 2) AND (NOT(ParamStr(1) = '-x') OR NOT(ParamStr(1) = '-y')) THEN BEGIN
    Scale(ParamStr(1), ParamStr(2), scaleX, scaleY);
  END ELSE IF (ParamCount = 4) AND (NOT(ParamStr(3) = '-x') OR NOT(ParamStr(3) = '-y')) THEN BEGIN
    IF ParamStr(1) = '-x' THEN BEGIN
      scaleX := StrToInt(ParamStr(2));
    END ELSE IF ParamStr(1) = '-y' THEN BEGIN
      scaleY := StrToInt(ParamStr(2));
    END;
    IF IsValidScaleFactor(scaleX) AND IsValidScaleFactor(scaleY) THEN BEGIN
      Scale(ParamStr(3), ParamStr(4), scaleX, scaleY);
    END ELSE BEGIN
      WriteLn('Invalid scale factor. Please ensure scale factors are between -9 and -2 or 2 and 9.');
    END;
  
  END ELSE BEGIN
    WriteLn('Invalid parameters. Please ensure scale factors are between -9 and -2 or 2 and 9.');
    WriteLn('Usage: ScaleASCII [-x scaleX] [-y scaleY] inFile.txt outFile.txt');
  END;
END.
