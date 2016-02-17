program lab1;
const lmax = 20;
var B, D, A: array[1..lmax] of real;
    i, k, n, nmax: integer;
    maximum, z, x, z1, z2, x1, y1: real;

begin
  writeln('Лабораторная работа №1');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задания: 14, 2, 4');
  
  { ### Задание 1 }
  writeln('Задание 1');
  repeat
    write('Введите натуральное число k от 1 до ', lmax);
    write(', длину массива B: ');
    read(k);
  until (k > 0) and (k < lmax);
  
  writeln('Введите массив B из ', k, ' элементов:');
  for i := 1 to k do
    read(B[i]);

  repeat
    write('Введите неположительные числа x и z, где x <= z: ');
    read(x, z);
  until (x <= 0) and (z <= 0) and (z >= x);
  
  maximum := 0;
  nmax := 0;
  for i := 1 to k do
    if (abs(B[i]) >= abs(maximum)) and
       (-z <= abs(B[i])) and
       (abs(B[i]) <= -x) then
    begin
      maximum := B[i];
      nmax := i;
    end;
    
  if nmax = 0 then
    writeln('Нет максимума.')
  else
    writeln('Максимум = ', maximum, ', его индекс в массиве = ', nmax);
  
  { ### Задание 2 }
  writeln;
  writeln('Задание 2');
  repeat
    write('Введите числа z1 и z2, где z1 <= z2: ');
    read(z1, z2);
  until (z1 <= z2);
  
  n := 0;
  for i := 1 to k do
    if (z1 <= B[i]) and (B[i] <= z2) then
    begin
      n := n + 1;
      D[n] := B[i];
    end;
    
  if n = 0 then
    writeln('Не удалось составить массивы D и A.')
  else
  begin
    writeln('Массив D из ', n, ' элементов');
    for i := 1 to n do
      write(D[i]:10:3, ' ');
    writeln;
    
    { ### Задание 3 }
    writeln;
    writeln('Задание 3');
    repeat
      write('Введите числа x1 и y1, где x1 < y1: ');
      read(x1, y1);
    until (x1 < y1);
    
    for i := 1 to n do
      if (-y1 < D[i]) and (D[i] < -x1) then
        if (D[i] < 0) then begin
          A[i] := 0;
          write('Элемент массива A[', i, '] не определён',
              ', поэтому считается нулём')
        end else
          A[i] := sqrt(D[i])
      else
        A[i] := D[i] / 3;
        
    writeln('Массив A из ', n, ' элементов');
    for i := 1 to n do
      write(A[i]:10:3);
    writeln;
  end;
end.
