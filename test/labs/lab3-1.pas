program lab3_prog1;
var i: integer;
    s, prev, cur, eps, x: real;

begin
  writeln('Лабораторная работа №3 программа 1');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, вариант задания 6');
  writeln('Задание №1');
  
  repeat
    write('Введите вещественное число eps большее нуля: ');
    read(eps);
  until (eps > 0);
  repeat
    write('Введите число x также большее нуля: ');
    read(x);
  until (x > 0);
  
  prev := (x - 1)/x;
  cur := sqr(x - 1)/(2*sqr(x));
  s := prev + cur;
  i := 2;
  while abs(cur) > eps do
  begin
    prev := cur;
    cur := prev * (i - 1)*(x - 1)/(i*x);
    s := s + cur;
    i := i + 1
  end;
  writeln('Полученное значение по формуле: ', s);
  writeln('Точное значение: ln(', x, ') = ', ln(x));
  writeln('Сравнение: |ln(x)-s| = ', abs(ln(x)-s));
  writeln('Отличие в ', 100*(1-s/ln(x)) : 7 : 6, '%');
end.