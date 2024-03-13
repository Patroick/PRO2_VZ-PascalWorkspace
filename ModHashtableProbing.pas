UNIT ModHashtableProbing;

INTERFACE
  PROCEDURE Lookup(key : STRING);
  PROCEDURE WriteHashtable;
  

IMPLEMENTATION
USES ModHashfunctions;

CONST
  M = 307;

TYPE
  Hashtable = ARRAY[0..M-1] OF STRING;

VAR 
  ht : Hashtable;
  numCollisions : INTEGER;

PROCEDURE Lookup(key : STRING);
VAR
  step, h : WORD;
  tries : INTEGER;
BEGIN
  IF key = '' THEN BEGIN
    WriteLn('Empty string is not alowed');
    HALT;
  END;
  h := Hash1(key) MOD M;
  step := HashRabinKarp(key); (* For double hashing *)
  (* Find free Slot *)
  tries := 0;
  WHILE (ht[h] <> '') AND (tries < M) DO BEGIN
    Inc(tries);
    //h := (h + 1) MOD M; (* Linear Probing *)
    //h := (h + tries * tries) MOD M; (* Quadratic Probing *)
    h := (h + 1 + step) MOD M; (* Double Hashing *)
  END;

  numCollisions := numCollisions + tries;

  IF ht[h] = '' THEN BEGIN
    ht[h] := key;
  END ELSE BEGIN
    WriteLn('Hashtable is full');
    HALT;
  END;
END;

PROCEDURE WriteHashtable;
VAR 
  i : INTEGER;
BEGIN
  FOR i := Low(ht) TO High(ht) DO BEGIN (* Von Start des Arrays bis Ende*)
    IF ht[i] <> '' THEN BEGIN
      WriteLn(i, ': ', ht[i]);
    END;
  END;
  Writeln('Number of collisions: ', numCollisions);
END;

VAR 
  i : INTEGER;

BEGIN (* ModHashtableProbing *)
  
  (* Init Hashtable *)
  FOR i := Low(ht) TO High(ht) DO BEGIN
    ht[i] := '';
  END;
  numCollisions := 0;

END. (* ModHashtableProbing *)