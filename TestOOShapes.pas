PROGRAM TestOOShapes;

USES ModOOShapes;

VAR
  s: Shape;
  c: Canvas;
  g1 : Shape;
  g: ShapeGroup;

BEGIN
  s := CreateLine(100, 100, 100, 300, petrol);
  c := CreateCanvas('shapes.svg');
  s^.Draw(c);
  s^.Erase(c);
  s^.Move(10, 10);
  s^.Draw(c);

  g := CreateGroup(black);
  g^.Add(CreateLine(300, 100, 300, 300, black));
  g^.Add(CreateLine(300, 300, 200, 500, black));
  g^.Add(CreateLine(300, 300, 400, 500, black));
  g^.Add(CreateLine(300, 100, 300, 100, black));
  g^.Add(CreateLine(300, 100, 200, 200, black));
  g^.Add(CreateEllipse(400, 200, 50, 50, black));
  g^.Draw(c);

  g1 := g^.DeepCopy;
  g1^.Move(100, 100);

  Dispose(c, Done);
  Dispose(s, Done);
  Dispose(g, Done);
  Dispose(g1, Done);
END.