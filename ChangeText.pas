(* ChangeText:                                                PP, 2024-04-17 *)
(* ------                                                                    *)
(* ChangeText                                                                *)
(* ========================================================================= *)

PROGRAM ChangeText;
                                                                
PROCEDURE ReplaceWordInLine(VAR line: STRING; wordPos: INTEGER; newWord: STRING);

  VAR
  spaceIdx, wordStart, wordEnd, i: INTEGER;
  tempLine: STRING;

  BEGIN
    spaceIdx := 0;
    wordStart := 1;
    tempLine := line;

    FOR i := 1 TO wordPos DO BEGIN
      spaceIdx := Pos(' ', tempLine);
      Delete(tempLine, 1, spaceIdx);
      wordStart := wordStart + spaceIdx;
    END;

    wordEnd := Pos(' ', tempLine);
    IF wordEnd = 0 THEN BEGIN
      wordEnd := Length(tempLine) + 1;
    END;
    Delete(line, wordStart, wordEnd - 1);
    Insert(newWord, line, wordStart);
  END;

  VAR
    originalFile, changeFile, outputFile: TEXT;
    line, position, i, wordIdx: INTEGER;
    newWord: STRING;
    buffer: STRING;                                                                                                             
    lines: ARRAY OF STRING;
    numLines: INTEGER;

BEGIN

  IF ParamCount <> 3 THEN BEGIN
      WriteLn('Usage: ChangeText <originalFile> <changeFile> <outputFile>');
      Halt(1);
  END;

  Assign(originalFile, ParamStr(1));
  Reset(originalFile);
  Assign(changeFile, ParamStr(2));
  Reset(changeFile);
  Assign(outputFile, ParamStr(3));
  Rewrite(outputFile);

  numLines := 0;
  SetLength(lines, 1000); 
  WHILE NOT Eof(originalFile) DO BEGIN
    ReadLn(originalFile, buffer);
    lines[numLines] := buffer;
    WriteLn(outputFile, buffer);
    Inc(numLines);
  END;

  WHILE NOT Eof(changeFile) DO BEGIN
    ReadLn(changeFile, buffer);
    wordIdx := Pos(' ', buffer);
    Val(Copy(buffer, 1, wordIdx - 1), line, i); 
    Delete(buffer, 1, wordIdx);

    wordIdx := Pos(' ', buffer);
    Val(Copy(buffer, 1, wordIdx - 1), position, i); 
    Delete(buffer, 1, wordIdx);

    newWord := buffer;

    ReplaceWordInLine(lines[line - 1], position - 1, newWord);
  END;

  Rewrite(outputFile);
  FOR i := 0 TO numLines - 1 DO BEGIN
    WriteLn(outputFile, lines[i]);
  END;

  Close(originalFile);
  Close(changeFile);
  Close(outputFile);
END.
