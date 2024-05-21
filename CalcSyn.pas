UNIT CalcSyn;

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
  PROCEDURE Expr; FORWARD;
  PROCEDURE Term; FORWARD;
  PROCEDURE Fact; FORWARD;

  PROCEDURE InitParser;
  BEGIN
    success := TRUE;
    NewSy;
  END;

  PROCEDURE S;
  BEGIN
    Expr; IF NOT success THEN EXIT;
    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  //Expr = Term { '+' Term | '-' Term }.
  PROCEDURE Expr;
  BEGIN
    Term; IF NOT success THEN EXIT;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      IF sy = plusSy THEN BEGIN
        NewSy; Term; IF NOT success THEN EXIT;
      END ELSE IF sy = minusSy THEN BEGIN
        NewSy; Term; IF NOT success THEN EXIT;
      END;
    END;
  END;

  //Term = Factor { '*' Fact | '/' Fact }.
  PROCEDURE Term;
  BEGIN
    Fact; IF NOT success THEN EXIT;
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      IF sy = mulSy THEN BEGIN
        NewSy; Fact; IF NOT success THEN EXIT;
      END ELSE IF sy = divSy THEN BEGIN
        NewSy; Fact; IF NOT success THEN EXIT;
      END;
    END;
  END;


  // Factor = number | '(' Expr ')'.
  PROCEDURE Fact;
  BEGIN
    IF sy = numSy THEN BEGIN
      IF sy <> numSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE IF sy = leftParSy THEN BEGIN
      IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
      Expr; IF NOT success THEN EXIT;
      IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE BEGIN
      success := FALSE; EXIT;
    END;
  END;


BEGIN

END.