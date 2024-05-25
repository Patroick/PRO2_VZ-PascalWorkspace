program ExpressionParser;

{$mode objfpc}{$H+}

type
  PNode = ^TNode;
  TNode = record
    left, right: PNode;
    val: string;
    id: integer;
  end;

var
  globalID: integer;

function CreateNode(AValue: string; var AId: integer): PNode;
var
  NewNode: PNode;
begin
  New(NewNode);
  with NewNode^ do
  begin
    val := AValue;
    left := nil;
    right := nil;
    id := AId;
    Inc(AId);
  end;
  Result := NewNode;
end;

function ParseExpr(var s: string; var idx: integer): PNode; forward;
function ParseTerm(var s: string; var idx: integer): PNode; forward;
function ParseFactor(var s: string; var idx: integer): PNode; forward;

function ParseExpr(var s: string; var idx: integer): PNode;
var
  currentNode, newNode: PNode;
  op: string;
begin
  currentNode := ParseTerm(s, idx);
  while (idx <= Length(s)) and (s[idx] in ['+', '-']) do
  begin
    while (s[idx] = ' ') do Inc(idx); // Skip spaces
    op := s[idx];
    Inc(idx); // Move past the operator
    while (s[idx] = ' ') do Inc(idx); // Skip spaces
    newNode := CreateNode(op, globalID);
    newNode^.left := currentNode;
    newNode^.right := ParseTerm(s, idx);
    currentNode := newNode;
  end;
  Result := currentNode;
end;

function ParseTerm(var s: string; var idx: integer): PNode;
var
  currentNode, newNode: PNode;
  op: string;
begin
  currentNode := ParseFactor(s, idx);
  while (idx <= Length(s)) and (s[idx] in ['*', '/']) do
  begin
    while (s[idx] = ' ') do Inc(idx); // Skip spaces
    op := s[idx];
    Inc(idx); // Move past the operator
    while (s[idx] = ' ') do Inc(idx); // Skip spaces
    newNode := CreateNode(op, globalID);
    newNode^.left := currentNode;
    newNode^.right := ParseFactor(s, idx);
    currentNode := newNode;
  end;
  Result := currentNode;
end;

function ParseFactor(var s: string; var idx: integer): PNode;
var
  num: string;
begin
  while (s[idx] = ' ') do Inc(idx); // Skip spaces
  if s[idx] = '(' then
  begin
    Inc(idx); // Skip '('
    Result := ParseExpr(s, idx);
    while (s[idx] = ' ') do Inc(idx); // Skip spaces
    if s[idx] = ')' then Inc(idx); // Skip ')'
  end
  else
  begin
    num := '';
    while (idx <= Length(s)) and (s[idx] in ['0'..'9']) do
    begin
      num := num + s[idx];
      Inc(idx);
    end;
    Result := CreateNode(num, globalID);
  end;
  while (idx <= Length(s)) and (s[idx] = ' ') do Inc(idx); // Skip trailing spaces
end;

procedure FreeTree(node: PNode);
begin
  if node <> nil then
  begin
    FreeTree(node^.left);
    FreeTree(node^.right);
    Dispose(node);
  end;
end;

procedure InOrderTraversal(node: PNode);
begin
  if node <> nil then
  begin
    InOrderTraversal(node^.left);
    Write(node^.val, ' ');
    InOrderTraversal(node^.right);
  end;
end;

procedure GenerateGraphviz(node: PNode);
begin
  if node <> nil then
  begin
    if node^.left <> nil then
      WriteLn('  ', node^.id, ' -> ', node^.left^.id, ';');
    if node^.right <> nil then
      WriteLn('  ', node^.id, ' -> ', node^.right^.id, ';');
    GenerateGraphviz(node^.left);
    GenerateGraphviz(node^.right);
  end;
end;

function Evaluate(node: PNode): integer;
var
  leftVal, rightVal: integer;
begin
  if (node^.left = nil) and (node^.right = nil) then
    Result := INTEGER(node^.val)
  else
  begin
    leftVal := Evaluate(node^.left);
    rightVal := Evaluate(node^.right);
    case node^.val[1] of
      '+': Result := leftVal + rightVal;
      '-': Result := leftVal - rightVal;
      '*': Result := leftVal * rightVal;
      '/': Result := leftVal div rightVal;
    end;
  end;
end;

var
  expr: string;
  idx: integer;
  root: PNode;
begin
  globalID := 1;
  Write('Enter expression: ');
  ReadLn(expr);
  idx := 1;
  root := ParseExpr(expr, idx);
  WriteLn('In-order traversal: ');
  InOrderTraversal(root);
  WriteLn;
  WriteLn('Graphviz output: ');
  WriteLn('digraph G {');
  GenerateGraphviz(root);
  WriteLn('}');
  WriteLn('Expression Result: ', Evaluate(root));
  FreeTree(root);
end.
