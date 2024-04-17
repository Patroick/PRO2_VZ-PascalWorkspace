(* CountWords:                                                PP, 2024-04-10 *)
(* ------                                                                    *)
(* Usage CountWords.exe <infile.txt> [<outfile.txt>]                         *)
(* Counts the number of words in each line and writes the content of         *)
(* <infile.txt> to <outfile.txt> and adds the number of words at the         *)
(* end of each line. If <outfilename.txt> is not specified the result        *)
(* is written to the console.                                                *)
(* ========================================================================= *)

PROGRAM CountWords;
  CONST
    tabCh = Chr(9);

  VAR 
    infile, outfile: TEXT;
    infilename, outfilename, line: STRING;
    ch: CHAR;
    wordCount: INTEGER;

BEGIN
  IF (ParamCount >= 1) AND (ParamCount < 3) THEN BEGIN
    infilename := ParamStr(1);
    outfilename := '';
    IF ParamCount = 2 THEN BEGIN
      outfilename := ParamStr(2);
    END;
  END ELSE BEGIN
    WriteLn('Usage: CountWords.exe <infile.txt> [<outfile.txt>]');
    HALT;
  END;
  Assign(infile, inFileName);
  Assign(outfile, outFileName);
  {$I-}
  Reset(infile);
  IF IOResult <> 0 THEN BEGIN
    WriteLn('Error: Could not open file ', inFileName);
    HALT;
  END;
  Rewrite(outfile);
  IF IOResult <> 0 THEN BEGIN
    WriteLn('Error: Could not open file ', outFileName);
    HALT;
  END;
  {$I+}
  WHILE NOT EOF(infile) DO BEGIN
    WHILE (NOT EOLn(infile)) AND (NOT EOF(infile)) DO BEGIN
      Read(infile, ch);
      IF (ch = ' ') OR (ch = tabCh) THEN BEGIN
        Inc(wordCount);
      END;
      Write(outfile, ch);
    END; (* WHILE *)
    Read(infile, ch);

    Read(infile, ch);
    WriteLn(' # words: ', wordCount);
    wordCount := 0;

  END;

  Close(infile);
  Close(outfile);

END.