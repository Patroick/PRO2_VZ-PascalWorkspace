PROGRAM UntypedBinFileDemo;

  VAR
    f1, f2: FILE;
    buf: ARRAY[0..1023] OF BYTE;
    bytesRead, bytesWritten, totalBytesRead, totalBytesWritten: LONGINT;

BEGIN (* UntypedBinFileDemo *)
  Assign(f1, 'person.db');
  Assign(f2, 'person_copy.db');
  Reset(f1, 1); (* 1 byte record size *)
  Rewrite(f2, 1);

  totalBytesRead := 0;
  totalBytesWritten := 0;

  REPEAT
    BlockRead(f1, buf, sizeof(buf), bytesRead);
    BlockWrite(f2, buf, bytesRead, bytesWritten);
    totalBytesRead := totalBytesRead + bytesRead;
    totalBytesWritten := totalBytesWritten + bytesWritten;
    WriteLn(FilePos(f1));
    IF bytesRead <> bytesWritten THEN BEGIN
      WriteLn('Error: bytesRead <> bytesWritten');
      Close(f1);
      Close(f2);
      HALT;
    END;
  UNTIL (bytesRead < sizeof(buf)); (* REPEAT *)

  WriteLn('Total bytes read: ', totalBytesRead);
  WriteLn('Total bytes written: ', totalBytesWritten);

  Close(f1);
  Close(f2);

END. (* UntypedBinFileDemo *)