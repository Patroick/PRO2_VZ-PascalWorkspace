(* textfiledemo:                                              pp, 2024-04-10 *)
(* ------                                                                    *)
(* textfiledemo                                                              *)
(* ========================================================================= *)

program textfiledemo;

  var
    f1, f2: text;
    ch: char;

begin (* textfiledemo *)
  
  assign(f1, 'textfiledemo.pas');
  assign(f2, 'textfiledemo_copy.pas');
  {$i-} (* i/o error checking off *)
  reset(f1); (* open file for reading *)
  if ioresult <> 0 then begin
    writeln('file not found');
    halt;
  end;
  rewrite(f2); (* open file for writing, overwrite if file exitst *)
  if ioresult <> 0 then begin
    writeln('file not found');
    halt;
  end;
  {$i+} (* i/o error checking on *)
  while not eof(f1) do begin (* eof = end of file, only for text file*)
    read(f1, ch); (* read form f1 *)
    write(f2, lowercase(ch)); 
  end;
  close(f1); 
  close(f2);


end. (* textfiledemo *)