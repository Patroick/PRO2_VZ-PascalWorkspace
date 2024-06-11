PROGRAM OODestructorDemo;

TYPE
  Logger = OBJECT
            PRIVATE
              log: TEXT;
              logName: STRING;
            PUBLIC
              CONSTRUCTOR Init(logName: STRING);
              PROCEDURE LogMsg(msg: STRING);
              DESTRUCTOR Done; VIRTUAL;
          END;
  ColorLogger = OBJECT(Logger)
            PROCEDURE LogWarning(msg: STRING);
            PROCEDURE LogError(msg: STRING);
          END;
  ColorLoggerPtr = ^ColorLogger;  
  LoggerPtr = ^Logger;


CONSTRUCTOR Logger.Init(logName: STRING);
BEGIN
  Assign(log, logName);
  SELF.logName := logName;
  {$I-}
  Append(log);
  {$I+}
  IF IOResult <> 0 THEN BEGIN
    Rewrite(log);
    IF IOResult <> 0 THEN BEGIN
      WriteLn('Error opening log file');
      HALT;
    END;
  END;
END;

PROCEDURE Logger.LogMsg(msg: STRING);
BEGIN
  WriteLn(log, msg);
  Flush(log);
END;

DESTRUCTOR Logger.Done;
BEGIN
  Close(log);
END;

PROCEDURE ColorLogger.LogWarning(msg: STRING);
BEGIN
  LogMsg('Yellow: '+ msg);
END;

PROCEDURE ColorLogger.LogError(msg: STRING);
BEGIN
  LogMsg('Red: '+ msg);
END;

VAR 
  l: ColorLoggerPtr;

BEGIN
  New(l, Init('log.txt'));
  WriteLn(l^.logName);
  
  l^.LogWarning('This is a test');
  l^.LogError('This is a test');
  Dispose(l, Done);
END.

