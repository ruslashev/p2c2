program lab5_prog3;
const lmax = 20;
type arr = array [1..lmax] of real;
var i, n : integer; nr : real; a : arr;

procedure uniq(var n : integer; var a : arr);
var nn, j : integer; na : arr;
begin
  nn := 0;
  for i : integer := 1 to n do begin
    j := 1;
    while (j <= nn) and (a[i] <> na[j]) do
      inc(j);
    if j > nn then begin
      inc(nn);
      na[nn] := a[i]
    end
  end;
  n := nn;
  a := na;
end;

procedure countRepeats(n : integer; var a : arr);
var reps, nn : integer; uniq : arr;
begin
  for i : integer := 1 to n do begin
    write('a[', i:2, '] = ', a[i]:2, ' ; ');
    reps := 0;
    for j : integer := 1 to n do
      if (i <> j) and (a[i] = a[j]) then
        inc(reps);
    writeln('встречается раз: ', reps);
  end
end;

begin
  writeln('Лабораторная работа №5 программа 3');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задание №3 (вар 2)');
  
  repeat
    write('Введите n: ');
    read(nr);
  until (nr > 0) and (nr <= lmax) and (nr = round(nr));
  n := round(nr);
  
  writeln('Введите массив:');
  for i := 1 to n do begin
    repeat
      write('Введите A[', i, ']: ');
      read(nr);
    until (abs(nr) < maxint) and (nr = round(nr));
    a[i] := round(nr);
  end;
  
  countRepeats(n, a);
  
  uniq(n, a);
  
  writeln('Массив B:');
  for i := 1 to n do
    write(a[i], ' ');
end.