PROGRAM BinaryFileDemo;

  TYPE
    PersonRec = RECORD
      name: STRING[50];
      org: STRING[50];
      val: INTEGER;
    END;

  VAR
    f1: FILE OF PersonRec;
    p1: PersonRec;

BEGIN
  Assign(f1, 'person.db');
  Rewrite(f1);
  p1.name := 'John Doe';
  p1.org := 'ACME';
  p1.val := 100;

  Seek(f1, 1);
  Write(f1, p1);
  p1.name := 'Jane Doe';
  Write(f1, p1);

  Seek(f1, 1);
  Read(f1, p1);
  WriteLn(p1.name, ' ', p1.org, ' ', p1.val);

  Close(f1);

END.