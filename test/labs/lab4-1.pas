program lab4_prog1;
const lmax = 20;
var A: array[1..lmax, 1..lmax] of integer;
    n, m, i, j, fz, lnz, t: integer;
    flag : boolean;

begin
  writeln('Лабораторная работа №4 программа 1');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, вариант задания 6');
  writeln('Задание №1');
  
  repeat
    write('Введите размер n матрицы A[1:n,1:m], натуральное число 2 до ',
        lmax, ': ');
    read(n);
  until (n >= 2) and (n <= lmax);
  repeat
    write('Введите размер m, натуральное число 1 до ', lmax, ': ');
    read(m);
  until (m >= 1) and (m <= lmax);
  
  writeln('Введите матрицу:');
  for i := 1 to n do
    for j := 1 to m do
      read(A[i,j]);
  
  fz := 0;
  i := 1;
  flag := false;
  while (i <= n) and (flag = false) do begin
    for j := 1 to m do
      if A[i,j] = 0 then begin
        fz := i;
        flag := true;
      end;
    i := i + 1;
  end;
  lnz := n;
  flag := false;
  while (lnz >= 1) and (flag = false) do begin
    flag := true;
    for j := 1 to m do
      if A[lnz,j] = 0 then
        flag := false;
    if not flag then lnz := lnz - 1;
  end;
  
  if fz = 0 then
    writeln('Нет строки с нулевым элементом')
  else if lnz = 0 then
    writeln('Нет строк не содержащих ни одного нуля')
  else begin
    for j := 1 to m do begin
      t := A[fz,j];
      A[fz,j] := A[lnz,j];
      A[lnz,j] := t
    end;
    
    writeln('Матрица A:');
    for i := 1 to n do begin
      for j := 1 to m do
        write(A[i,j]:3);
      writeln
    end
  end;
end.