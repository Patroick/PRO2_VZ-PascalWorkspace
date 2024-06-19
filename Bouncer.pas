(*Bouncer1:                                            MiniLib V.4, 2004
  --------
  Bouncing ball application.
  Version 1: without ball interaction.
========================================================================*)
PROGRAM Bouncer1;

	USES
		MetaInfo, OSBridge,
    MLObj, MLWin, MLAppl;

	TYPE
		BouncerWindow = ^BouncerWindowObj;
		BouncerWindowObj = OBJECT(MLWindowObj)
				pos: Point;
        dx, dy, size, speed: INTEGER;
				CONSTRUCTOR Init(title: STRING);
		  (*overridden methods*)
        PROCEDURE Open; VIRTUAL;
				PROCEDURE Redraw; VIRTUAL;
				PROCEDURE OnIdle; VIRTUAL;
				PROCEDURE OnCommand(commandNr: INTEGER); VIRTUAL;
		  (*new methods*)
				PROCEDURE InvertBall; VIRTUAL;
				PROCEDURE ChangeSize(newSize: INTEGER); VIRTUAL;
				PROCEDURE ChangeSpeed(newSpeed: INTEGER); VIRTUAL;
			END; (*OBJECT*)

		BouncerApplication= ^BouncerApplicationObj;
		BouncerApplicationObj = OBJECT(MLApplicationObj)
				CONSTRUCTOR Init(name: STRING);
	    (*overridden methods*)
				PROCEDURE OpenNewWindow; VIRTUAL;
				PROCEDURE BuildMenus; VIRTUAL;
			END; (*OBJECT*)

	VAR
  (*size menu:*)
		smallCommand, mediumCommand, largeCommand: INTEGER;
  (*speed menu:*)
		crawlCommand, walkCommand, runCommand, flyCommand: INTEGER;


(*=== BouncerWindow ===*)

	FUNCTION NewBouncerWindow: BouncerWindow;
		VAR
			w: BouncerWindow;
	BEGIN
		New(w, Init('Bouncer Window'));
		NewBouncerWindow := w;
	END; (*NewBouncerWindow*)

	CONSTRUCTOR BouncerWindowObj.Init(title: STRING);
	BEGIN
		INHERITED Init(title);
    Register('BouncerWindow', 'MLWindow');
		pos.x :=  0;
		pos.y :=  0;
		size  := 10;
		speed := 10;
		dx    := speed;
		dy    := speed;
	END; (*BouncerWindowObj.Init*)

	PROCEDURE BouncerWindowObj.Open;
	BEGIN
		INHERITED Open;
    InvertBall;
	END; (*BouncerWindowObj.Open*)

	PROCEDURE BouncerWindowObj.Redraw;
	BEGIN
		InvertBall;
	END; (*BouncerWindowObj.Redraw*)

	PROCEDURE BouncerWindowObj.OnIdle;

		PROCEDURE Move(VAR val, delta: INTEGER; max: INTEGER);
		BEGIN
			val := val + delta;
			IF val < 0 THEN BEGIN
				val   := 0;
				delta := + speed;
			END (*THEN*)
			ELSE IF val + size > max THEN BEGIN
				val   := max - size;
				delta := -speed;
			END; (*ELSE*)
		END; (*Move*)

	BEGIN (*BouncerWindowObj.OnIdle*)
	  InvertBall;
		Move(pos.x, dx, Width);
		Move(pos.y, dy, Height);
		InvertBall;
	END; (*BouncerWindowObj.OnIdle*)

	PROCEDURE BouncerWindowObj.OnCommand(commandNr: INTEGER);
	BEGIN
    IF commandNr = smallCommand THEN
			ChangeSize(10)
		ELSE IF commandNr = mediumCommand THEN
			ChangeSize(20)
		ELSE IF commandNr = largeCommand THEN
			ChangeSize(40)
		ELSE IF commandNr = crawlCommand THEN
			ChangeSpeed(1)
		ELSE IF commandNr = walkCommand THEN
			ChangeSpeed(5)
		ELSE IF commandNr = runCommand THEN
			ChangeSpeed(10)
		ELSE IF commandNr = flyCommand THEN
			ChangeSpeed(20)
		ELSE
			INHERITED OnCommand(commandNr);
	END; (*BouncerWindowObj.OnCommand*)

	PROCEDURE BouncerWindowObj.InvertBall;
	BEGIN
		DrawFilledOval(pos, size, size);
	END; (*BouncerWindowObj.InvertBall*)

	PROCEDURE BouncerWindowObj.ChangeSize(newSize: INTEGER);
	BEGIN
		InvertBall;
		size := newSize;
		InvertBall;
	END; (*BouncerWindowObj.ChangeSize*)

	PROCEDURE BouncerWindowObj.ChangeSpeed(newSpeed: INTEGER);
	BEGIN
		speed := newSpeed;
		IF dx < 0 THEN
			dx := -speed
		ELSE
			dx := speed;
		IF dy < 0 THEN
			dy := -speed
		ELSE
			dy := speed;
	END; (*BouncerWindowObj.ChangeSpeed*)


(*=== BouncerApplication ===*)

	FUNCTION NewBouncerApplication: BouncerApplication;
		VAR
			a: BouncerApplication;
	BEGIN
		New(a, Init('Bouncer Application V.1'));
		NewBouncerApplication := a;
	END; (*NewBouncerApplication*)

	CONSTRUCTOR BouncerApplicationObj.Init(name: STRING);
	BEGIN
		INHERITED Init(name);
		Register('BouncerApplication', 'MLApplication');
	END; (*BouncerApplicationObj.Init*)

	PROCEDURE BouncerApplicationObj.OpenNewWindow;
	BEGIN
		NewBouncerWindow^.Open;
	END; (*BouncerApplicationObj.OpenNewWindow*)

	PROCEDURE BouncerApplicationObj.BuildMenus;
	BEGIN
  (*size menu:*)
		smallCommand  := NewMenuCommand('Size',  'Small',  'S');
		mediumCommand := NewMenuCommand('Size',  'Medium', 'M');
		largeCommand  := NewMenuCommand('Size',  'Large',  'L');
  (*speed menu:*)
		crawlCommand  := NewMenuCommand('Speed', 'Crawl',  '1');
		walkCommand   := NewMenuCommand('Speed', 'Walk',   '2');
		runCommand    := NewMenuCommand('Speed', 'Run',    '3');
		flyCommand    := NewMenuCommand('Speed', 'Fly',    '4');
	END; (*BouncerApplicationObj.BuildMenus*)


(*=== main program ===*)

	VAR
		a: MLApplication;

BEGIN (*Bouncer1*)
	a := NewBouncerApplication;
	a^.Run;
	Dispose(a, Done);
	WriteMetaInfo;
END. (*Bouncer1*)
