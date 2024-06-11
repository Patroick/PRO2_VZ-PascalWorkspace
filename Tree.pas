UNIT Tree;

INTERFACE

TYPE
  TreeNode = ^Node;
  Node = RECORD
    expr: STRING;
    left, right: TreeNode;
  END;

FUNCTION MakeNode(expr: STRING; left, right: TreeNode): TreeNode;
PROCEDURE DisposeTree(VAR tree: TreeNode);

IMPLEMENTATION

  FUNCTION MakeNode(expr: STRING; left, right: TreeNode): TreeNode;
  VAR
    newNode: TreeNode;
  BEGIN
    New(newNode);
    newNode^.expr := expr;
    newNode^.left := left;
    newNode^.right := right;
    MakeNode := newNode;
  END;

  PROCEDURE DisposeTree(VAR tree: TreeNode);
  BEGIN
    IF tree <> NIL THEN
    BEGIN
      DisposeTree(tree^.left); 
      DisposeTree(tree^.right); 
      Dispose(tree);
      tree := NIL;
    END;
  END;

END.
