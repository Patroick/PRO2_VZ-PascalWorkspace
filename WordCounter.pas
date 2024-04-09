(* WordCounter:                                  HDO, 2003-02-28 *)
(* -----------                                                   *)
(* Template for programs that count words in text files.         *)
(*===============================================================*)
PROGRAM WordCounter;

  USES
    Timer, WordReader;

  CONST
    M = 1000;

  TYPE
    NodePtr = ^Node;
    Node = RECORD
      word: STRING;
      count: LONGINT;
      next: NodePtr;
    END;
    Hashtable = ARRAY[0..M-1] OF NodePtr;

  VAR
    ht : Hashtable;

  FUNCTION HashRabinKarp(s : STRING): LONGWORD;
  VAR
    i : INTEGER;
    h : LONGWORD;
  BEGIN
    h := Ord(s[1]);
    FOR i := 2 TO Length(s) DO
      h := (h * 256 + Ord(s[i])) MOD 65521;
    HashRabinKarp := h;
  END;

  FUNCTION NewNode(key : STRING): NodePtr;
    VAR n : NodePtr;
  BEGIN (* NewNode *)
    New(n);
    n^.word := key;
    n^.count := 1;
    n^.next := NIL;
    NewNode := n;
  END; (* NewNode *)

  PROCEDURE Lookup(key : STRING);
  VAR
    h : LONGWORD;
    current : NodePtr;

  BEGIN
    h := HashRabinKarp(key) MOD M;
    current := ht[h];
    WHILE (current <> NIL) AND (current^.word <> key) DO BEGIN
      current := current^.next;
    END;
    IF current = NIL THEN BEGIN
      current := NewNode(key);
      current^.next := ht[h];
      ht[h] := current;
    END ELSE BEGIN
      Inc(current^.count);
    END;
  END; 

  PROCEDURE DisposeHashtable;
  VAR
    i : INTEGER;
    current : NodePtr;

  BEGIN
    (*dispose all nodes in the hashtable*)
    FOR i := Low(ht) TO High(ht) DO BEGIN
      current := ht[i];
      WHILE current <> NIL DO BEGIN
        ht[i] := current^.next;
        Dispose(current);
        current := ht[i];
      END;
    END;
  END;


  VAR
    w: LONGWORD;
    n: LONGINT;

BEGIN 
  WriteLn('WordCounter:');
  OpenFile('se.txt', toLower);
  StartTimer;
  n := 0;
  ReadWord(w);
  WHILE w <> '' DO BEGIN
    n := n + 1;
    (*insert word in data structure and count its occurence*)
    ReadWord(w);
    Write(w);
    Write(' ');
  END; (*WHILE*)
  StopTimer;
  CloseFile;
  WriteLn;
  WriteLn('number of words: ', n);
  WriteLn('elapsed time:    ', ElapsedTime);
  (*search in data structure for word with max. occurrence*)

  DisposeHashtable();
END. (*WordCounter*)