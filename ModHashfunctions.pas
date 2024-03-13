UNIT ModHashfunctions;

INTERFACE

FUNCTION Hash1(s : STRING): WORD;  
FUNCTION Hash2(s : STRING): WORD;
FUNCTION HashRabinKarp(s : STRING): WORD;

IMPLEMENTATION

FUNCTION Hash1(s : STRING): WORD;
BEGIN
  Hash1 := Ord(s[1]) * 17 + Length(s);
END;

FUNCTION Hash2(s : STRING): WORD;
BEGIN
  Hash2 := Ord(s[1]) * 17 + Ord(s[Length(s)]); 
END;

FUNCTION HashRabinKarp(s : STRING): WORD;
VAR
  i : INTEGER;
  h : WORD;
BEGIN
  h := Ord(s[1]);
  FOR i := 2 TO Length(s) DO
    h := (h * 256 + Ord(s[i])) MOD 65521;
  HashRabinKarp := h;
END;

BEGIN (* ModHashfunctions *)
  
END. (* ModHashfunctions *)