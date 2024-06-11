UNIT ModOOShapes;

INTERFACE
TYPE
  ColorType = (blue, petrol, black, white, raspberry, orange, yellow);
  Canvas = ^CanvasObj;
  CanvasObj = OBJECT
                CONSTRUCTOR Init;
                DESTRUCTOR Done; VIRTUAL;
                PROCEDURE DrawLine(x1, y1, x2, y2: INTEGER; c: ColorType); VIRTUAL; ABSTRACT;
                PROCEDURE DrawEllipse(x, y, w, h: INTEGER; c: ColorType); VIRTUAL; ABSTRACT;
              END;
  SvgCanvas = ^SvgCanvasObj;
  SvgCanvasObj = OBJECT(CanvasObj)
                    PRIVATE
                      f: TEXT;
                    PUBLIC
                      CONSTRUCTOR Init(filename: STRING);
                      DESTRUCTOR Done; VIRTUAL;
                      PROCEDURE DrawLine(x1, y1, x2, y2: INTEGER; c : ColorType); VIRTUAL;
                      PROCEDURE DrawEllipse(x, y, w, h: INTEGER; c: ColorType); VIRTUAL;
                END;
  Shape = ^ShapeObj;
  ShapeObj = OBJECT
              PROTECTED
                color: ColorType;
                CONSTRUCTOR Init(c: ColorType);
              PUBLIC
                PROCEDURE Draw(c: Canvas); VIRTUAL; ABSTRACT;
                PROCEDURE Erase(c: Canvas); VIRTUAL; ABSTRACT;
                PROCEDURE Move(dx, dy: INTEGER); VIRTUAL; ABSTRACT;
                FUNCTION DeepCopy: Shape; VIRTUAL; ABSTRACT;
                DESTRUCTOR Done; VIRTUAL;
            END;
  Line = ^LineObj;
  LineObj = OBJECT(ShapeObj)
              PRIVATE
                x1, y1, x2, y2: INTEGER;
              PUBLIC  
                CONSTRUCTOR Init(x1, y1, x2, y2: INTEGER; c: ColorType);
                PROCEDURE Draw(c: Canvas); VIRTUAL;
                PROCEDURE Erase(c: Canvas); VIRTUAL;
                PROCEDURE Move(dx, dy: INTEGER); VIRTUAL;
                FUNCTION DeepCopy: Shape; VIRTUAL;
            END;
  Rectangle = ^RectangleObj;
  RectangleObj = OBJECT(ShapeObj)
                    PRIVATE
                      x, y, width, height: INTEGER;
                    PUBLIC
                      CONSTRUCTOR Init(x, y, width, height: INTEGER; c: ColorType);
                      PROCEDURE Draw(c: Canvas); VIRTUAL;
                      PROCEDURE Erase(c: Canvas); VIRTUAL;
                      PROCEDURE Move(dx, dy: INTEGER); VIRTUAL;
                      FUNCTION DeepCopy: Shape; VIRTUAL;
                END;
  Ellipse = ^EllipseObj;
  EllipseObj = OBJECT(ShapeObj)
                    PRIVATE
                      x, y, width, height: INTEGER;
                    PUBLIC
                      CONSTRUCTOR Init(x, y, width, height: INTEGER; c: ColorType);
                      PROCEDURE Draw(c: Canvas); VIRTUAL;
                      PROCEDURE Erase(c: Canvas); VIRTUAL;
                      PROCEDURE Move(dx, dy: INTEGER); VIRTUAL;
                      FUNCTION DeepCopy: Shape; VIRTUAL;
                END;
  ShapeGroup = ^ShapeGroupObj;
  ShapeGroupObj = OBJECT(ShapeObj)
                    CONST maxShapes = 20;
                    PRIVATE
                      shapes: ARRAY[1..maxShapes] OF Shape;
                      numShapes: INTEGER;
                    PUBLIC
                      CONSTRUCTOR Init(c: ColorType);
                      DESTRUCTOR Done; VIRTUAL;
                      PROCEDURE Add(s: Shape); VIRTUAL;
                      PROCEDURE Remove(s: Shape); VIRTUAL;
                      PROCEDURE Draw(c: Canvas); VIRTUAL;
                      PROCEDURE Erase(c: Canvas); VIRTUAL;
                      PROCEDURE Move(dx, dy: INTEGER); VIRTUAL;
                      FUNCTION DeepCopy: Shape; VIRTUAL;
                END;

FUNCTION CreateCanvas(filename: STRING): Canvas;
FUNCTION CreateLine(x1, y1, x2, y2: INTEGER; c: ColorType): Line;
FUNCTION CreateRect(x, y, w, h: INTEGER; c: ColorType): Rectangle;
FUNCTION CreateEllipse(x, y, w, h: INTEGER; c: ColorType): Ellipse;
FUNCTION CreateGroup(c: ColorType): ShapeGroup;


IMPLEMENTATION
(************************************************************)

CONSTRUCTOR ShapeObj.Init(c: ColorType);
BEGIN
  color := c;
END;

DESTRUCTOR ShapeObj.Done;
BEGIN
  (* empty *)
END;

CONSTRUCTOR LineObj.Init(x1, y1, x2, y2: INTEGER; c: ColorType);
BEGIN
  INHERITED Init(c);
  SELF.x1 := x1;
  SELF.y1 := y1;
  SELF.x2 := x2;
  SELF.y2 := y2;
END;

PROCEDURE LineObj.Draw(c: Canvas);
BEGIN
  //WriteLn('Drawing line from (', x1, ',', y1, ') to (', x2, ',', y2, ') in ', color);
  c^.DrawLine(x1, y1, x2, y2, color);
END;

PROCEDURE LineObj.Erase(c: Canvas);
BEGIN
  //WriteLn('Erasing line from (', x1, ',', y1, ') to (', x2, ',', y2, ')');
  c^.DrawLine(x1, y1, x2, y2, color);
END;

PROCEDURE LineObj.Move(dx, dy: INTEGER);
BEGIN
  x1 := x1 + dx;
  y1 := y1 + dy;
  x2 := x2 + dx;
  y2 := y2 + dy;
END;

FUNCTION LineObj.DeepCopy: Shape;
VAR
  l: Line;
BEGIN
  New(l, Init(x1, y1, x2, y2, color));
  DeepCopy := l;
END;

(************************************************************)

CONSTRUCTOR EllipseObj.Init(x, y, width, height: INTEGER; c: ColorType);
BEGIN
  INHERITED Init(c);
  SELF.x := x;
  SELF.y := y;
  SELF.width := width;
  SELF.height := height;
END;

PROCEDURE EllipseObj.Draw(c: Canvas);
BEGIN
  //WriteLn('Drawing Ellipse at (', x, ',', y, ') with width ', width, ' and height ', height, ' in ', color);
  c^.DrawEllipse(x, y, width, height, color);
END;

PROCEDURE EllipseObj.Erase(c: Canvas);
BEGIN
  //WriteLn('Erasing Ellipse at (', x, ',', y, ') with width ', width, ' and height ', height);
  c^.DrawEllipse(x, y, width, height, white);
END;

PROCEDURE EllipseObj.Move(dx, dy: INTEGER);
BEGIN
  x := x + dx;
  y := y + dy;
END;

FUNCTION EllipseObj.DeepCopy: Shape;
VAR
  e: Ellipse;
BEGIN
  New(e, Init(x, y, width, height, color));
  DeepCopy := e;
END;

(************************************************************)

CONSTRUCTOR RectangleObj.Init(x, y, width, height: INTEGER; c: ColorType);
BEGIN
  INHERITED Init(c);
  SELF.x := x;
  SELF.y := y;
  SELF.width := width;
  SELF.height := height;
END;

PROCEDURE RectangleObj.Draw(c: Canvas);
BEGIN
  //WriteLn('Drawing rectangle at (', x, ',', y, ') with width ', width, ' and height ', height, ' in ', color);
  c^.DrawLine(x,         y,          x + width, y,          color);
  c^.DrawLine(x + width, y,          x + width, y + height, color);
  c^.DrawLine(x + width, y + height, x,         y + height, color);
  c^.DrawLine(x,         y + height, x,         y,          color);
END;

PROCEDURE RectangleObj.Erase(c: Canvas);
BEGIN
  //WriteLn('Erasing rectangle at (', x, ',', y, ') with width ', width, ' and height ', height);
  c^.DrawLine(x,         y,          x + width, y,          white);
  c^.DrawLine(x + width, y,          x + width, y + height, white);
  c^.DrawLine(x + width, y + height, x,         y + height, white);
  c^.DrawLine(x,         y + height, x,         y,          white);
END;

PROCEDURE RectangleObj.Move(dx, dy: INTEGER);
BEGIN
  x := x + dx;
  y := y + dy;
END;

FUNCTION RectangleObj.DeepCopy: Shape;
VAR
  r: Rectangle;
BEGIN
  New(r, Init(x, y, width, height, color));
  DeepCopy := r;
END;

(************************************************************)

CONSTRUCTOR ShapeGroupObj.Init(c: ColorType);
VAR i : INTEGER;
BEGIN
  INHERITED Init(c);
  numShapes := 0;
  FOR i := 1 TO maxShapes DO BEGIN
    shapes[i] := NIL;
  END;
END;

DESTRUCTOR ShapeGroupObj.Done;
VAR i : INTEGER;
BEGIN
  FOR i := 1 TO numShapes DO BEGIN
    Dispose(shapes[i], Done);
  END;
END; 

PROCEDURE ShapeGroupObj.Add(s: Shape);
BEGIN
  IF numShapes >= maxShapes THEN BEGIN
    WriteLn('ShapeGroup is full');
    HALT;
  END;
  numShapes := numShapes + 1;
  shapes[numShapes] := s;
END;

PROCEDURE ShapeGroupObj.Remove(s: Shape);
VAR i: INTEGER;
BEGIN
  i := 1;
  WHILE (i <= numShapes) AND (shapes[i] <> s) DO BEGIN
    i := i + 1;
  END;

  (* shift elements one position to the left *)
  IF i <= numShapes THEN BEGIN
    WHILE i < numShapes DO BEGIN
      shapes[i] := shapes[i+1];
      i := i + 1;
    END;
   END;
END;

PROCEDURE ShapeGroupObj.Draw(c: Canvas);
VAR i: INTEGER;
BEGIN
  FOR i := 1 TO numShapes DO BEGIN
    shapes[i]^.Draw(c);
  END;
END;

PROCEDURE ShapeGroupObj.Erase(c: Canvas);
VAR i: INTEGER;
BEGIN
  FOR i := 1 TO numShapes DO BEGIN
    shapes[i]^.Erase(c);
  END;
END;

PROCEDURE ShapeGroupObj.Move(dx, dy: INTEGER);
VAR i: INTEGER;
BEGIN
  FOR i := 1 TO numShapes DO BEGIN
    shapes[i]^.Move(dx, dy);
  END;
END;

FUNCTION ShapeGroupObj.DeepCopy: Shape;
VAR
  g: ShapeGroup;
  i: INTEGER;
BEGIN
  New(g, Init(color));
  FOR i := 1 TO numShapes DO BEGIN
    g^.Add(shapes[i]^.DeepCopy);
  END;
  DeepCopy := g;
END;  

(************************************************************)

CONSTRUCTOR SvgCanvasObj.Init(filename: STRING);
BEGIN
  INHERITED Init;
  Assign(f, filename);
  Rewrite(f);
  WriteLn(f, '<svg height="1000" width="1000" xmlns="http://www.w3.org/2000/svg">');
END;

DESTRUCTOR SvgCanvasObj.Done;
BEGIN
  WriteLn(f, '</svg>');
  Close(f);
  INHERITED Done;
END;

PROCEDURE SvgCanvasObj.DrawLine(x1, y1, x2, y2: INTEGER; c: ColorType);
BEGIN
  WriteLn(f, '<line x1="', x1, '" y1="', y1, '" x2="', x2, '" y2="', y2, '" style="stroke:', c, ';stroke-width:2" />');
END;

PROCEDURE SvgCanvasObj.DrawEllipse(x, y, w, h: INTEGER; c: ColorType);
VAR rx, ry, cx, cy: INTEGER;
BEGIN
  rx := w DIV 2;
  ry := h DIV 2;
  cx := x + rx;
  cy := y + ry;
  WriteLn(f, '<ellipse rx="', rx, '" ry="', ry, '" cx="', cx, '" cy="', cy, '" style="fill:transparent;stroke:', c, ';stroke-width:2" />');
END;


(************************************************************)

CONSTRUCTOR CanvasObj.Init;
BEGIN
  (* empty *)
END;

DESTRUCTOR CanvasObj.Done;
BEGIN
  (* empty *)
END;

FUNCTION CreateCanvas(filename: STRING): Canvas;
VAR
  c: SvgCanvas;
BEGIN
  New(c, Init(filename));
  CreateCanvas := c;
END;

FUNCTION CreateLine(x1, y1, x2, y2: INTEGER; c: ColorType): Line;
VAR
  l: Line;
BEGIN
  New(l, Init(x1, y1, x2, y2, c));
  CreateLine := l;
END;

FUNCTION CreateRect(x, y, w, h: INTEGER; c: ColorType): Rectangle;
VAR
  r: Rectangle;
BEGIN
  New(r, Init(x, y, w, h, c));
  CreateRect := r;
END;

FUNCTION CreateEllipse(x, y, w, h: INTEGER; c: ColorType): Ellipse;
VAR
  e: Ellipse;
BEGIN
  New(e, Init(x, y, w, h, c));
  CreateEllipse := e;
END;

FUNCTION CreateGroup(c: ColorType): ShapeGroup;
VAR
  g: ShapeGroup;
BEGIN
  New(g, Init(c));
  CreateGroup := g;
END;

BEGIN

END.