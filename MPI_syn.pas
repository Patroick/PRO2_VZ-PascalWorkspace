UNIT MPI_syn;

INTERFACE
VAR 
  success : BOOLEAN;
  PROCEDURE s;

IMPLEMENTATION
  USES  MP_Lex;

  PROCEDURE MP; FORWARD;
  PROCEDURE VarDecl; FORWARD;
  PROCEDURE StatSeq; FORWARD;
  PROCEDURE Stat; FORWARD;
  PROCEDURE Expr; FORWARD;
  PROCEDURE Term; FORWARD;
  PROCEDURE Fact; FORWARD;

  PROCEDURE S;
  BEGIN
    success := TRUE;
    MP; IF NOT success THEN EXIT;
    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  PROCEDURE MP;
  BEGIN
    IF sy <> programSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> semicolonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy = varSy THEN BEGIN
      VarDecl; IF NOT success THEN EXIT;
    END;

    IF sy <> beginSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    StatSeq; IF NOT success THEN EXIT;

    IF sy <> endSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> periodSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  PROCEDURE VarDecl;
  BEGIN
    IF sy <> varSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    WHILE sy = commaSy DO BEGIN
      NewSy;
      IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END;

    IF sy <> colonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> intSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;

    IF sy <> semicolonSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
  END;

  PROCEDURE StatSeq;
  BEGIN
    Stat; IF NOT success THEN EXIT;

    WHILE sy = semicolonSy DO BEGIN
      NewSy; (* Skip ';' *)
      Stat; IF NOT success THEN EXIT;
    END;
  END;

  PROCEDURE Stat;
  BEGIN
    IF (sy = identSy) OR (sy = readSy) OR (sy = writeSy) THEN BEGIN
      CASE sy OF 
        identSy: 
                BEGIN
                  NewSy;
                  IF sy <> assignSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                  Expr; IF NOT success THEN EXIT;
                END;
        readSy:
                BEGIN
                  NewSy; (* Skip read *)
                  IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                  IF sy <> identSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                  IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                END;
        writeSy:
                BEGIN
                  NewSy; (* Skip write *)
                  IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                  Expr; IF NOT success THEN EXIT;
                  IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
                  NewSy;
                END;
      END;
    END;
  END;

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

  PROCEDURE Fact;
  BEGIN
    IF sy = identSy THEN BEGIN
      NewSy;
    END ELSE IF sy = numberSy THEN BEGIN
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