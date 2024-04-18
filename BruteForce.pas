(* BruteForce:                                                 Author, 2024-03-20 *)
(* ------                                                                    *)
(* Description                                                               *)
(* ========================================================================= *)

PROGRAM PatternMatching;

  TYPE
    PatternMatchingFunc = FUNCTION(s, p: STRING): INTEGER;

  VAR 
    numbComp: INTEGER;

  FUNCTION Eq(a, b: CHAR): BOOLEAN;
  BEGIN
    numbComp := numbComp + 1;
    Eq := a = b;
  END;

  FUNCTION BruteForce1(s, p: STRING): INTEGER;
  VAR
    i, j, n, m: INTEGER;
  BEGIN
    n := Length(s);
    m := Length(p);

    IF (n >= 1) AND (m >= 1) THEN BEGIN
      i := 1;
      j := 1;
  
      WHILE (i <= n - m + 1) AND (j = 1) DO BEGIN
        WHILE (j <= m) AND (Eq(s[i + j - 1], p[j]) OR (p[j] = '?')) DO BEGIN
          j := j + 1;
        END;
        IF j <= m THEN BEGIN
          j := 1;
        END;
        Inc(i);
      END;
      IF j > m THEN BEGIN 
      BruteForce1 := i - 1;
      END ELSE BEGIN 
        BruteForce1 := 0; 
      END
    END ELSE BEGIN
      BruteForce1 := 0;
    END;
  END;

  FUNCTION BruteForce2(s, p: STRING): INTEGER;
  VAR
    i, j, n, m: INTEGER;
  BEGIN
    n := Length(s);
    m := Length(p);
    IF (m < 1) OR (m < 1) THEN BEGIN
      BruteForce2 := 0;
    END ELSE BEGIN
      i := 1;
      j := 1;
      REPEAT
        IF Eq(s[i], p[j]) THEN BEGIN
          i := i + 1;
          j := j + 1;
        END ELSE BEGIN
          i := i - j + 2;
          j := 1;
        END;
      UNTIL (j > m) OR (i > n); 
      IF j > m THEN BEGIN
        BruteForce2 := i - j + 1;
      END ELSE BEGIN
        BruteForce2 := 0;
      END;
    END;
  END;

FUNCTION BruteForceRL(s, p: STRING): INTEGER;
VAR
  i, j, n, m: INTEGER;
BEGIN
  n := Length(s);
  m := Length(p);
  IF (n < m) OR (m < 1) THEN BEGIN
    BruteForceRL := 0;
  END ELSE BEGIN
    j := m;
    i := m;
    REPEAT
      IF Eq(s[i], p[j]) THEN BEGIN
        Dec(i);
        Dec(j);
      END ELSE BEGIN
        i := i + m - j + 1;
        j := m;
      END;
    UNTIL (j = 0) OR (i > n); (* REPEAT *)
    IF j = 0 THEN BEGIN
      BruteForceRL := i + 1;
    END ELSE BEGIN
      BruteForceRL := 0;
    END;
  END;
END;

FUNCTION BoyerMoore(s, p: STRING): INTEGER;
VAR
  i, j, n, m: INTEGER;
  skip: ARRAY[CHAR] OF INTEGER;
  
  PROCEDURE InitSkip;
  VAR
    ch : CHAR;
  BEGIN
    FOR ch := LOW(skip) TO HIGH(skip) DO BEGIN
      skip[ch] := m;
    END;
    i := 1;
    WHILE i <= m DO BEGIN
      skip[p[i]] := m - i;
      Inc(i);
    END;
  END;
BEGIN
  n := Length(s);
  m := Length(p);
  IF (n < m) OR (m < 1) THEN BEGIN
    BoyerMoore := 0;
  END ELSE BEGIN
    InitSkip;
    j := m;
    i := m;
    REPEAT
      IF Eq(s[i], p[j]) THEN BEGIN
        Dec(i);
        Dec(j);
      END ELSE BEGIN
        IF i + skip[s[i]] > i + m - j THEN BEGIN
          i := i + skip[s[i]];
        END ELSE BEGIN
          i := i + m - j + 1;
        END;
        j := m;
      END;
    UNTIL (j = 0) OR (i > n); (* REPEAT *)
    IF j = 0 THEN BEGIN
      BoyerMoore := i + 1;
    END ELSE BEGIN
      BoyerMoore := 0;
    END;
  END;
END;

FUNCTION KnuthMorrisPratt1(s, p: STRING): INTEGER;
  VAR
    i, j, n, m: INTEGER;
    next: ARRAY[1..255] OF INTEGER;

    PROCEDURE InitNext;
    BEGIN
      m := Length(p);
      i := 1;
      j := 0;
      next[1] := 0;
      REPEAT
        IF (j = 0) OR Eq(p[i], p[j]) THEN BEGIN
          i := i + 1;
          j := j + 1;
          next[i] := j;
        END ELSE BEGIN
          j := next[j];
        END;
      UNTIL i > m;
    END;

  BEGIN
    n := Length(s);
    m := Length(p);
    IF (n < 1) OR (m < 1) THEN BEGIN
      KnuthMorrisPratt1 := 0;
    END ELSE BEGIN
      InitNext;
      i := 1;
      j := 1;
      REPEAT
        IF (j = 0) OR Eq(s[i], p[j]) THEN BEGIN
          i := i + 1;
          j := j + 1;
        END ELSE BEGIN
          j := next[j];
        END;
      UNTIL (j > m) OR (i > n); 
      IF j > m THEN BEGIN
        KnuthMorrisPratt1 := i - j + 1;
      END ELSE BEGIN
        KnuthMorrisPratt1 := 0;
      END;
    END;
  END;

  FUNCTION KnuthMorrisPratt2(s, p: STRING): INTEGER;
  VAR
    i, j, n, m: INTEGER;
    next: ARRAY[1..255] OF INTEGER;

    PROCEDURE InitNext;
    BEGIN
      m := Length(p);
      i := 1;
      j := 0;
      next[1] := 0;
      REPEAT
        IF (j = 0) OR Eq(p[i], p[j]) THEN BEGIN
          i := i + 1;
          j := j + 1;
          IF  NOT Eq(p[j], p[i]) THEN BEGIN
            next[i] := next[j];
          END ELSE BEGIN
            next [i] := next[j] + 1;
          END;
        END ELSE BEGIN
          j := next[j];
        END;
      UNTIL i > m;
    END;

  BEGIN
    n := Length(s);
    m := Length(p);
    IF (n < 1) OR (m < 1) THEN BEGIN
      KnuthMorrisPratt2 := 0;
    END ELSE BEGIN
      InitNext;
      i := 1;
      j := 1;
      REPEAT
        IF (j = 0) OR Eq(s[i], p[j]) THEN BEGIN
          i := i + 1;
          j := j + 1;
        END ELSE BEGIN
          j := next[j];
        END;
      UNTIL (j > m) OR (i > n); 
      IF j > m THEN BEGIN
        KnuthMorrisPratt2 := i - j + 1;
      END ELSE BEGIN
        KnuthMorrisPratt2 := 0;
      END;
    END;
  END;

  FUNCTION RabinKarp(s, p: STRING): INTEGER;
  CONST b = 256;
        q = 65257;
  VAR
    i, j, n, m, pos: INTEGER;
    hs, hp, bp: WORD;
  BEGIN
    m := Length(p);
    n := Length(s);
    IF (n < m) OR (m < 1) THEN BEGIN
      RabinKarp := 0;
    END ELSE BEGIN
      hs := 0; hp := 0;
      FOR i := 1 TO m DO BEGIN
        hp := (hp * b + Ord(p[i])) MOD q;
        hs := (hs * b + Ord(s[i])) MOD q;
      END;
      (* bp = b^(m-1) *)
      bp := 1;
      FOR i := 1 TO m - 1 DO BEGIN
        bp := (bp * b) MOD q;
      END;
      i := 1;
      pos := 0;
      WHILE (pos = 0) AND (i <= n - m + 1) DO BEGIN
        IF hs = hp THEN BEGIN
          (* check all characters *)
          j := 1;
          WHILE (j <= m) AND (s[i+j-1] = p[j]) DO BEGIN
            Inc(j);
          END;
          IF j > m THEN BEGIN
            pos := i;
          END;
        END;

        IF (pos = 0) AND (i <= n - m) THEN BEGIN
          hs := (hs + b*q - Ord(s[i]) * bp) MOD q;
          hs := (hs * b) MOD q;
          hs := (hs + Ord(s[i + m])) MOD q;
        END; 

      Inc(i);
      END;
    RabinKarp := pos;
    END;
  END;

  PROCEDURE Test(alg: PatternMatchingFunc);
    PROCEDURE Test1(s, p: STRING; expectedPos: INTEGER);
    VAR
      pos: INTEGER;
    BEGIN
      pos := alg(s,p);
      IF pos = expectedPos THEN BEGIN
        WriteLn('Position of ', p, ' in ', s, ' is ', pos, ' num. of comparisons: ', numbComp);
        numbComp := 0;
      END ELSE BEGIN
        WriteLn('Error: Position of ', p, ' in ', s, ' is ', pos, ' but should be ', expectedPos);
        HALT;
      END;
    END;
  BEGIN
    Test1('Hagenberg', 'berg', 6);
    Test1('ababababc', 'abc', 7);
    Test1('', 'b', 0);
    Test1('a', '', 0);
    Test1('bbbbbbbbbbbbbbbbbbbbbb', 'xxx', 0);
  END;

BEGIN
  Test(BruteForce1);
  Test(BruteForce2);
  Test(KnuthMorrisPratt1);
  WriteLn('BruteForceRL: '); Test(BruteForceRL);
  WriteLn('BoyerMoore: '); Test(BoyerMoore);
  WriteLn('RabinKarp: '); Test(RabinKarp);
END.