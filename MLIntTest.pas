PROGRAM TestMLInt;
USES MLObj, MLInteger, MetaInfo;

VAR i, j: MLInt;

BEGIN
  New(i, Init(17));
  WriteLn(i^.Class);
  WriteLn(i^.BaseClass);
  WriteLn(i^.IsA('MLInt'));
  WriteLn(i^.IsA('MLObject'));
  
  New(j, Init(21));
  WriteLn(i^.IsLessThan(j));
  WriteLn(j^.IsLessThan(i));
  WriteLn(i^.IsEqualTo(j));
  i^.WriteAsString;
  j^.WriteAsString;

  Dispose(i, Done);
  Dispose(j, Done);
  WriteMetaInfo;
END.