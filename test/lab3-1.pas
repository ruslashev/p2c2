program lab3_prog1;
var i: integer;
    s, prev, cur, eps, x: real;

begin
  writeln('������������ ������ �3 ��������� 1');
  writeln('������� ������, ������ ���155, ������� 141, ������� ������� 6');
  writeln('������� �1');
  
  repeat
    write('������� ������������ ����� eps ������� ����: ');
    read(eps);
  until (eps > 0);
  repeat
    write('������� ����� x ����� ������� ����: ');
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
  writeln('���������� �������� �� �������: ', s);
  writeln('������ ��������: ln(', x, ') = ', ln(x));
  writeln('���������: |ln(x)-s| = ', abs(ln(x)-s));
  writeln('������� � ', 100*(1-s/ln(x)) : 7 : 6, '%');
end.