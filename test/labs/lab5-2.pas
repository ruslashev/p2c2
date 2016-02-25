program lab5_prog2;
const lmax = 20;
var i, j, n, m : integer; nr, mr, min, max : real;
    a : array [1..lmax, 1..lmax] of real;
begin
  writeln('Лабораторная работа №5 программа 2');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задание №2 (вар 7)');
  
  repeat
    write('Введите n: ');
    read(nr);
  until (nr > 0) and (nr <= lmax) and (nr = round(nr));
  n := round(nr);
  repeat
     write('Введите m: ');
     read(mr);
  until (mr > 0) and (mr <= lmax) and (mr = round(mr));
  m := round(mr);
  
  writeln('Введите матрицу:');
  for i := 1 to n do
      for j := 1 to m do
       read(a[i,j]);

  max := a[1,1];
  for i := 1 to n do begin
    min := maxint;
    for j := 1 to m do
      if abs(a[i,j]) < abs(min) then
        min := a[i,j];
    if min > max then
      max := min;
  end;

  writeln('D = ', max);
end.