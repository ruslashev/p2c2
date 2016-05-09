program lab3_prog2;
const lmax = 20;
var A: array[1..lmax, 1..lmax] of integer;
    B: array[1..lmax] of array[1..lmax] of integer;
    i, j, n, t, nodd: integer;

begin
  writeln('Лабораторная работа №3 программа 2');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, варианты заданий 7 и 2');
  writeln('Задание №2');
  
  repeat
    write('Введите размер матрицы A, натуральное число n от 3 до ', lmax, ': ');
    read(n);
  until (n >= 3) and (n <= lmax);
  
  writeln('Введите матрицу:');
  for i := 1 to n do
    for j := 1 to n do
      read(A[i,j]);

  for i := 1 to n-1 do
    for j := i+1 to n do
      if A[1,i] > A[1,j] then
      begin
        t := A[1,i];
        A[1,i] := A[1,j];
        A[1,j] := t
      end;
  
  writeln('Три минимальных элемента на первой строке: ',
      A[1,1], ' ', A[1,2], ' ', A[1,3]);
  
  writeln('Задание №3');
  nodd := 0;
  for i := 1 to n do
    if A[i, n-i+1] mod 2 <> 0 then
      nodd := nodd + 1;
  
  if nodd = 0 then
    writeln('Нет нечётных элементов')
  else
    writeln('Нечётных элементов на побочной диагонали: ', nodd);
end.
