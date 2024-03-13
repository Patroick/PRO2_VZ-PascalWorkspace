PROGRAM HashtableDemo;
USES ModHashtableProbing;

VAR 
  s : STRING;

BEGIN (* HashtableDemo *)
  ReadLn(s);
  WHILE s <> '' DO BEGIN
    Lookup(s);
    ReadLn(s);
  END;
  WriteHashtable;
END. (* HashtableDemo *)