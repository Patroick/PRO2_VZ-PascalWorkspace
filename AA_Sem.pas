UNIT AA_Sem;

INTERFACE

  TYPE 
    NodePtr = ^Node;
    Node = RECORD
      left, right: NodePtr;
      val: STRING;
    END;
    TreePtr = NodePtr;

  PROCEDURE InitParser;
  FUNCTION S : TreePtr;
  PROCEDURE InOrderTraversal(root: TreePtr);
  PROCEDURE PostOrderTraversal(root: TreePtr);
  PROCEDURE PreOrderTraversal(root: TreePtr);
  PROCEDURE DisposeTree(root: TreePtr);
  FUNCTION ValueOf(t: TreePtr): INTEGER;

  VAR
    success: BOOLEAN;

IMPLEMENTATION
  USES AA_Lex, SysUtils;

  PROCEDURE Expr(VAR e : TreePtr); FORWARD;
  PROCEDURE Term(VAR t : TreePtr); FORWARD;
  PROCEDURE Fact(VAR f : TreePtr); FORWARD;

  PROCEDURE InitParser;
  VAR input: STRING;
  BEGIN
    success := TRUE;
    Write('Expression: ');
    ReadLn(input);
    InitScanner(input);
    NewSy;
  END;

  FUNCTION NewNode(val: STRING; left, right: NodePtr): NodePtr;
  VAR n: NodePtr;
  BEGIN
    New(n);
    n^.val := val;
    n^.left := left;
    n^.right := right;
    NewNode := n;
  END;

  FUNCTION S : TreePtr;
  VAR
    e : TreePtr;
  BEGIN
    Expr(e); IF NOT success THEN EXIT;
    IF sy <> eofSy THEN BEGIN success := FALSE; EXIT; END;
    NewSy;
    S := e;
  END;

  PROCEDURE Expr(VAR e : TreePtr);
  VAR t : TreePtr;
    left: NodePtr;
    right: NodePtr;

  BEGIN
    Term(e); IF NOT success THEN EXIT;
    (* SEM *)
      left := e;
    (* ENDSEM *)
    WHILE (sy = plusSy) OR (sy = minusSy) DO BEGIN
      IF sy = plusSy THEN BEGIN
        NewSy; Term(t); IF NOT success THEN EXIT;
        (* SEM *)
        right := t;
        e := NewNode('+', left, right);
        left := e;
        (* ENDSEM *)
      END ELSE IF sy = minusSy THEN BEGIN
        NewSy; Term(t); IF NOT success THEN EXIT;
        (* SEM *)
        right := t;
        e := NewNode('-', left, right);
        left := e;
        (* ENDSEM *)
      END;
    END;
  END;

  PROCEDURE Term(VAR t : TreePtr);
  VAR f : TreePtr;
    left: NodePtr;
    right: NodePtr;
  BEGIN
    Fact(t); IF NOT success THEN EXIT;
    (* SEM *)
      left := t;
    (* ENDSEM *)
    WHILE (sy = mulSy) OR (sy = divSy) DO BEGIN
      IF sy = mulSy THEN BEGIN
        NewSy; Fact(f); IF NOT success THEN EXIT;
        (* SEM *)
        right := f;
        t := NewNode('*', left, right);
        left := t;
        (* ENDSEM *)
      END ELSE IF sy = divSy THEN BEGIN
        NewSy; Fact(f); IF NOT success THEN EXIT;
        (* SEM *)
        right := f;
        t := NewNode('/', left, right);
        left := t;
        (* ENDSEM *)
      END;
    END;
  END;

  PROCEDURE Fact(VAR f: TreePtr);
  BEGIN
    IF sy = numSy THEN BEGIN
      (* SEM *)
      f := NewNode(numberVal, NIL, NIL);
      (* ENDSEM *)
      NewSy;
    END ELSE IF sy = leftParSy THEN BEGIN
      NewSy;
      Expr(f); IF NOT success THEN EXIT;
      IF sy <> rightParSy THEN BEGIN success := FALSE; EXIT; END;
      NewSy;
    END ELSE BEGIN
      success := FALSE; EXIT;
    END;
  END;

  PROCEDURE InOrderTraversal(root: TreePtr);
  BEGIN
    IF root <> NIL THEN BEGIN
      InOrderTraversal(root^.left);
      WriteLn(root^.val);
      InOrderTraversal(root^.right);
    END;
  END;

  PROCEDURE PostOrderTraversal(root: TreePtr);
  BEGIN
    IF root <> NIL THEN BEGIN
      PostOrderTraversal(root^.left);
      PostOrderTraversal(root^.right);
      WriteLn(root^.val);
    END;
  END;

  PROCEDURE PreOrderTraversal(root: TreePtr);
  BEGIN
    IF root <> NIL THEN BEGIN
      WriteLn(root^.val);
      PreOrderTraversal(root^.left);
      PreOrderTraversal(root^.right);
    END;
  END;

  PROCEDURE DisposeTree(root: TreePtr);
  BEGIN
    IF root <> NIL THEN BEGIN
      DisposeTree(root^.left);
      DisposeTree(root^.right);
      Dispose(root);
    END;
  END;

  FUNCTION ValueOf(t: TreePtr): INTEGER;
  VAR
    leftValue, rightValue: INTEGER;
  BEGIN
    IF t = NIL THEN BEGIN
      ValueOf := 0;
      EXIT;
    END;
    IF (t^.left = NIL) AND (t^.right = NIL) THEN BEGIN
      ValueOf := StrToInt(t^.val);
      EXIT;
    END;

    leftValue := ValueOf(t^.left);
    rightValue := ValueOf(t^.right);

    CASE t^.val[1] OF
      '+': ValueOf := leftValue + rightValue;
      '-': ValueOf := leftValue - rightValue;
      '*': ValueOf := leftValue * rightValue;
      '/': ValueOf := leftValue DIV rightValue;
    ELSE
      ValueOf := 0;
    END;
  END;

BEGIN

END.
