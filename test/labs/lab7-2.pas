program p2;

var
  inf, outf: Text;
  inFilename, outFilename, row: String;
  counter, i: Integer;

begin
  writeln('Лабораторная работа №7');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задание 2 (7)');

  repeat
    write('Введите имя читаемого файла: ');
    readln(inFilename)
  until FileExists(inFilename);
  assign(inf, inFilename);
  reset(inf);
  
  repeat
    write('Имя файла для записи: ');
    readln(outFilename);
    if FileExists(outFilename)
      then writeln('Файл с таким именем уже существует')
  until CanCreateFile(outFilename) and not FileExists(outFilename);
  assign(outf, outFilename);
  rewrite(outf);
  
  counter := 0;
  while not eof(inf) do begin
    readln(inf, row);
    for i := 1 to length(row) do begin
      while (row[i] in ['0'..'9']) and (i <= length(row)) do begin
        inc(counter);
        inc(i);
      end;
      if counter >= 2 then begin
        counter := 0;
        insert('A', row, i);
      end else
        counter := 0;
    end;
    writeln(outf, row);
  end;
  
  close(inf);
  close(outf);
end.