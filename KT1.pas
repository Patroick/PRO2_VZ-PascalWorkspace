PROGRAM BruteForce;

  FUNCTION Pos(s, p: STRING): INTEGER;
    VAR
      i, j, n, m, skipped: INTEGER;
      prev: STRING;
  BEGIN
    n := Length(s);
    m := Length(p);
    i := 1;
    j := 1;
    REPEAT
      IF s[i] = p[j] THEN BEGIN
        Inc(i);
        Inc(j);
      END ELSE BEGIN
        i := i - j + 2;
        j := 1;
      END;
    UNTIL (i > n) OR (j > m);
    IF (j > m) THEN BEGIN
      pos := i - j + 1;
    END ELSE BEGIN
      pos := 0;
    END;
  END;

  VAR
    s, p: STRING;

BEGIN

  s := 'Halllo';
  p := 'llo';

  WriteLn('pos := ', Pos(s, p));
END.