program p1;

var
  r, rmax: Real;
  f: File of Real;
  filename, buf: String;
  err, nn, i: Integer;

begin
  writeln('Лабораторная работа №7');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задание 1 (10)');

  repeat
    write('Имя файла записи: ');
    readln(filename);
  until CanCreateFile(filename);
  
  assign(f, filename);
  
  rewrite(f);
  
  repeat
    write('Введите количество чисел: ');
    readln(buf);
    val(buf, nn, err)
  until (err = 0) and (nn > 0);
  for i := 1 to nn do begin
    repeat
      write('Введите элемент №', i, ': ');
      readln(buf);
      val(buf, r, err)
    until (err = 0);
    write(f, r);
  end;
  
  close(f);
  
  reset(f);
  
  rmax := 0;
  i := 1;
  while not eof(f) do begin
    read(f, r);
    if ((r > rmax) or (rmax = 0)) and (i mod 2 = 1)
      then rmax := r;
    inc(i);
  end;
  writeln('Максимальное число: ', rmax);
  
  close(f);
end.
