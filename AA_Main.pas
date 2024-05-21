PROGRAM AA_Main;
USES AA_Lex, AA_Sem;

VAR
  root: TreePtr;

BEGIN
  InitParser;
  root := S;  (* Assuming this parses and builds the tree, storing the root in a global variable or accessible location *)
  IF success THEN BEGIN
    WriteLn('In-order traversal:');
    InOrderTraversal(root);
    WriteLn('Post-order traversal:');
    PostOrderTraversal(root);
    WriteLn('Pre-order traversal:');
    PreOrderTraversal(root);
    WriteLn('Value: ', ValueOf(root));
  END ELSE BEGIN
    WriteLn('Parsing failed.');
  END;
  DisposeTree(root);
END.
