(* MChain:                                                    PP, 2024-04-09 *)
(* ------                                                                    *)
(* MChain                                                                    *)
(* ========================================================================= *)

PROGRAM MChain;

  FUNCTION MFor(s: STRING): INTEGER;
  VAR
    i, m: INTEGER;
    uniqueChars: ARRAY[1..256] OF BOOLEAN;
  BEGIN
    FOR i := 1 TO 256 DO BEGIN
      uniqueChars[i] := FALSE;
    END;
    m := 0;
    FOR i := 1 TO Length(s) DO BEGIN
      IF NOT uniqueChars[Ord(s[i])] THEN BEGIN
        uniqueChars[Ord(s[i])] := TRUE;
        m := m + 1;
      END;
    END;
    MFor := m;
  END;

  FUNCTION MaxMStringLen(s: STRING; m: INTEGER): INTEGER;
  VAR
    i, j, maxLen: INTEGER;
    current: STRING;
  BEGIN
    maxLen := 0;
    FOR i := 1 TO Length(s) DO BEGIN
      j := i;
      current := '';
      WHILE (j <= Length(s)) AND (MFor(current) < m) DO BEGIN
        j := j + 1;
        current := current + s[j];
        IF j - i > maxLen THEN BEGIN
          maxLen := j - i;
        END;
      END;
    END;
    MaxMStringLen := maxLen;
  END;


BEGIN

  WriteLn('MFor von a ' , MFor('a'));
  WriteLn('MFor von aaaa ' , MFor('aaaa'));
  WriteLn('MFor von abc ' , MFor('abc'));
  WriteLn('MFor von abcbbcda ' , MFor('abcbbcda'));
  WriteLn('MFor von abcde ' , MFor('abcde'));
  WriteLn('MFor von "" ' , MFor(''));


  WriteLn('abccc mit m 2 -> ', MaxMStringLen('abccc', 2));
  WriteLn('abccc mit m 3 -> ', MaxMStringLen('abccc', 3));
  WriteLn('abccc mit m 4 -> ', MaxMStringLen('abccc', 4));
  WriteLn('skdfakljlkdwerkljds mit m 5 -> ', MaxMStringLen('skdfakljlkdwerkljds', 5));

END.
