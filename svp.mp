PROGRAM Fakultat;
VAR n, f: INTEGER;

BEGIN
  f := n; n := n - 1;
  IF n THEN BEGIN
    f := 1;
  END;
  WRITE(f);
END.