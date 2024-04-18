(* WildcardPatternMatching:                                   PP, 2024-04-09 *)
(* ------                                                                    *)
(* WildcardPatternMatching                                                   *)
(* ========================================================================= *)

PROGRAM WildcardPatternMatching;

	FUNCTION BruteForceMatching(p: STRING; s: STRING): BOOLEAN;
	VAR
		i, j, n, m: INTEGER;
	BEGIN
		n := Length(s);
		m := Length(p);
		IF (n >= 1) AND (m >= 1) THEN BEGIN
      i := 1;
      j := 1;
      WHILE (i <= n - m + 1) AND (j = 1) DO BEGIN
        WHILE (j <= m) AND (s[i + j - 1] = p[j]) OR (p[j] = '?') DO BEGIN
          j := j + 1;
        END;
        IF j <= m THEN BEGIN
          j := 1;
        END;
        Inc(i);
      END;
      IF j > m THEN BEGIN 
      BruteForceMatching := true;
      END ELSE BEGIN 
        BruteForceMatching := false; 
      END
    END ELSE BEGIN
      BruteForceMatching := false;
    END;
	END;

	FUNCTION Matching(p, s: STRING): BOOLEAN;
	BEGIN
	IF (Length(p) = 0) THEN
		Matching := (Length(s) = 0)
	ELSE IF (Length(s) = 0) THEN
		Matching := (p[1] = '*') AND Matching(Copy(p, 2, Length(p) - 1), s)
	ELSE IF (p[1] = '*') THEN
		Matching := Matching(p, Copy(s, 2, Length(s) - 1)) OR Matching(Copy(p, 2, Length(p) - 1), s)
	ELSE IF (p[1] = '?') OR (s[1] = p[1]) THEN
		Matching := Matching(Copy(p, 2, Length(p) - 1), Copy(s, 2, Length(s) - 1))
	ELSE
		Matching := FALSE;
	END;

	TYPE
		PatternMatchingFunc = FUNCTION(p, s: STRING): BOOLEAN;

	PROCEDURE Test(alg: PatternMatchingFunc);
		PROCEDURE Test1(p, s: STRING);
		VAR
			found: BOOLEAN;
		BEGIN
			found := alg(p,s);
      IF found THEN BEGIN
        WriteLn(p, ' = ', s);
      END ELSE BEGIN
        WriteLn(p, ' != ', s);
      END;
    END;
	BEGIN
		Test1('ABC$', 'ABC$');
		Test1('ABC$', 'AB$');
		Test1('ABC$', 'ABCD$');
		Test1('A?C$', 'AXC$');
		Test1('*$', 'ABC$');
		Test1('A*C$', 'AC$');
		Test1('A*C$', 'AXYZC$');
	END;

BEGIN
	WriteLn('BruteForceMatching');
	Test(BruteForceMatching);
	WriteLn;
	WriteLn('Matching');
	Test(Matching);
	WriteLn;
END. (* WildcardPatternMatching. *)
