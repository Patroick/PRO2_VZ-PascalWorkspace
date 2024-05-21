UNIT CalcSem;

INTERFACE

  (* G(S): 
   * S = Expr eofSy.
   * Expr = Term { '+' Term | '-' Term }.
   * Term = Factor { '*' Fact | '/' Fact }.
   * Factor = number | '(' Expr ')'.
  *)

  PROCEDURE InitParser;
  PROCEDURE S; (* Satzsymbol *)
  VAR
    success: BOOLEAN;

IMPLEMENTATION
  USES CalcLex;
  PROCEDURE Expr(VAR e : INTEGER); FORWARD;
  PROCEDURE Term(VAR t : INTEGER); FORWARD;
  PROCEDURE Fact(VAR f : INTEGER); FORWARD;

  PROCEDURE InitParser;
  BEGIN
    success := TRUE;
    NewSy;
  END;

  PROCEDURE S;
  VAR
    e : INTEGER;
  BEGIN
    Expr(e); IF NOT success THEN EXIT;
    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
    (* SEM *)
    WriteLn('Ergebnis: ', e);
    (* ENDSEM *)
  END;

  //Expr = Term { '+' Term | '-' Term }.
  PROCEDURE Expr(VAR e : INTEGER);
  VAR t : INTEGER;
  BEGIN
    Term(e); IF NOT success THEN EXIT;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      IF sy = plusSy THEN BEGIN
        NewSy; Term(t); IF NOT success THEN EXIT;
        (* SEM *)
        e := e + t;
        (* ENDSEM *)
      END ELSE IF sy = minusSy THEN BEGIN
        NewSy; Term(t); IF NOT success THEN EXIT;
        (* SEM *)
        e := e - t;
        (* ENDSEM *)
      END;
    END;
  END;

  //Term = Factor { '*' Fact | '/' Fact }.
  PROCEDURE Term(VAR t : INTEGER);
  VAR f : INTEGER;
  BEGIN
    Fact(t); IF NOT success THEN EXIT;
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      IF sy = mulSy THEN BEGIN
        NewSy; Fact(f); IF NOT success THEN EXIT;
        (* SEM *)
        t := t * f;
        (* ENDSEM *)
      END ELSE IF sy = divSy THEN BEGIN
        NewSy; Fact(f); IF NOT success THEN EXIT;
        (* SEM *)
        t := t DIV f;
        (* ENDSEM *)
      END;
    END;
  END;


  // Factor = number | '(' Expr ')'.
  PROCEDURE Fact(VAR f: INTEGER);
  BEGIN
    IF sy = numSy THEN BEGIN
      IF sy <> numSy THEN BEGIN success := FALSE; EXIT; END;
      (* SEM *)
      f := numberVal;
      (* ENDSEM *)
      NewSy;
    END ELSE IF sy = leftParSy THEN BEGIN
      IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
      Expr(f); IF NOT success THEN EXIT;
      IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE BEGIN
      success := FALSE; EXIT;
    END;
  END;


BEGIN

END.