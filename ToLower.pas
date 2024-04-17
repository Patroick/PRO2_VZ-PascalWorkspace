(* ToLower:                                                   PP, 2024-04-10 *)
(* ------                                                                    *)
(* ToLower                                                                   *)
(* ========================================================================= *)

PROGRAM ToLower;

  VAR
    f1, f2: TEXT;
    infilename, outfilename: STRING;
    ch: CHAR;

BEGIN (* TextFileDemo *)

  IF ParamCount = 2 THEN BEGIN
    WriteLn('Usage: ToLower.exe <infilename> [ <outfilename> ]');
    WriteLn('default <outfilename>: <infilename>_copy.txt');
    HALT;
  END;

  (* ToLower.exe <infilename> [ <outfilename> ] *)
  (* default <outfilename>: <infilename>_copy.txt *)
  infilename := '';
  outfilename := '';
  IF ParamCount >= 1 THEN BEGIN
    infilename := ParamStr(1);
    IF ParamCount = 2 THEN BEGIN
      outfilename := ParamStr(2);
    END;
  END;

  Assign(f1, infilename);
  Assign(f2, outfilename);
  {$I-} (* I/O error checking off *)
  Reset(f1); (* open file for reading *)
  IF IOResult <> 0 THEN BEGIN
    WriteLn('File TextFileDemo.pas not found');
    HALT;
  END;
  Rewrite(f2); (* open file for writing, overwrite if file exitst *)
  IF IOResult <> 0 THEN BEGIN
    WriteLn('File TextFileDemo_copy.pas not found');
    HALT;
  END;
  {$I+} (* I/O error checking on *)
  WHILE NOT EOF(f1) DO BEGIN (* EOF = End of File, only for text file*)
    Read(f1, ch); (* read from f1 *)
    Write(f2, LowerCase(ch)); 
  END;
  Close(f1); 
  Close(f2);


END. (* ToLower *)