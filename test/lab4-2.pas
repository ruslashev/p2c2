program lab4_prog2;
const lmax = 20;
var B: array[1..lmax] of integer;
    k, i, t: integer;

begin
  writeln('Лабораторная работа №4 программа 2');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, вариант задания 2');
  writeln('Задание №2');
  
  repeat
    write('Введите k, длину массива B, натуральное число от 1 до ', lmax, ': ');
    read(k);
  until (k >= 1) and (k <= lmax);
  
  writeln('Введите массив:');
  for i := 1 to k do begin
    read(t);
    B[i] := 0;
    while t > 0 do begin
      B[i] := B[i] * 10 + (t mod 10);
      t := t div 10;
    end;
  end;
  
  writeln('Массив B:');
  for i := 1 to k do
    write(B[i], ' ');
end.