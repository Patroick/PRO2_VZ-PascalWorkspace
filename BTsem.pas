UNIT BTSem;

INTERFACE

  TYPE 
    NodePtr = ^Node; 
    Node = RECORD 
                left, right: NodePtr; 
                val: STRING; (* operator or operand as string *) 
            END; (* Node *) 
    TreePtr = NodePtr;

  FUNCTION S: TreePtr;
  PROCEDURE InitParser;

  VAR success: BOOLEAN;

IMPLEMENTATION

  USES AA_Lex;

  PROCEDURE TreePreOrder(t: TreePtr);
  PROCEDURE TreeInOrder(t: TreePtr);
  PROCEDURE TreePostOrder(t: TreePtr);

  PROCEDURE Expr(VAR e: NodePtr);
  PROCEDURE Term(VAR t: NodePtr);
  PROCEDURE Fact(VAR f: NodePtr);

  PROCEDURE InitParser;
  BEGIN
    success := TRUE;
    NewSy; (* get first symbol *)
  END;
  
  FUNCTION NewNode(input: STRING; left, right: NodePtr): NodePtr;
    VAR
      n: NodePtr;
  BEGIN
    New(n);
    n^.left := left;
    n^.right := right;
    n^.val := input;
    NewNode := n;
  END;
  
  (* S    = Expr eofSy . *)
  FUNCTION S: TreePtr;
    VAR
      e: NodePtr;
  BEGIN
    New(e);
    Expr(e); IF NOT success THEN Exit;
    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
    (* SEM *) 
    S := e;
    (* ENDSEM *)
  END;

  (* Expr = Term { '+' Term | '-' Term } . *)
  PROCEDURE Expr(VAR e: NodePtr);
    VAR
      t: NodePtr;
  BEGIN
    New(e);
    Term(e); IF NOT success THEN EXIT;
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      (* '+' Term | '-' Term *)
      IF sy = plusSy THEN BEGIN
        NewSy; (* skip + *)
        New(t);
        Term(t); IF NOT success THEN EXIT;
        (* SEM *) 
        e := NewNode('+', e, t);
        (* ENDSEM*)
      END ELSE IF sy = minusSy THEN BEGIN
        NewSy; (* skip - *)
        New(t);
        Term(t); IF NOT success THEN EXIT;
        (* SEM *) 
        e := NewNode('-', e, t);
        (* ENDSEM*)
      END;
    END;
  END;

  (* Term = Fact { '*' Fact | '/' Fact } . *)
  PROCEDURE Term(VAR t: NodePtr);
    VAR
      f: NodePtr;
  BEGIN
    Fact(t); IF NOT success THEN EXIT;
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      (* '*' Fact | '/' Fact *)
      IF sy = mulSy THEN BEGIN
        NewSy; (* skip * *)
        Fact(f); IF NOT success THEN EXIT;
        (* SEM *) 
        t := NewNode('*', t, f);
        (* ENDSEM*)
      END ELSE IF sy = divSy THEN BEGIN
        NewSy; (* skip / *)
        Fact(f); IF NOT success THEN EXIT;
        (* SEM *) 
        t := NewNode('/', t, f);
        (* ENDSEM*)
      END;
    END;
  END;

  (* Fact = number | '(' Expr ')' . *)
  PROCEDURE Fact(VAR f: NodePtr);
  BEGIN
    IF sy = numSy THEN BEGIN
      IF sy <> numSy THEN BEGIN success := FALSE; EXIT; END;
      (* SEM *) f := NewNode(numberVal, NIL, NIL); (* ENDSEM*)
      NewSy;
    END ELSE IF sy = leftParSy THEN BEGIN
      IF sy <> leftParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;

      Expr(f); IF NOT success THEN EXIT;

      IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE BEGIN
      success := FALSE;
      Exit;
    END;
  END;

  PROCEDURE TreePreOrder(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      Write(t^.val, ' ');
      TreePreOrder(t^.left);
      TreePreOrder(t^.right);
    END;
  END;

  PROCEDURE TreeInOrder(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      TreeInOrder(t^.left);
      Write(t^.val, ' ');
      TreeInOrder(t^.right);
    END;
  END;

  PROCEDURE TreePostOrder(t: TreePtr);
  BEGIN
    IF t <> NIL THEN BEGIN
      TreePostOrder(t^.left);
      TreePostOrder(t^.right);
      Write(t^.val, ' ');
    END;
  END;

BEGIN
END.