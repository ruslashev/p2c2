program lab2;
const lmax = 20;
var R: array[1..lmax] of real;
    i, n, k, f, nmax: integer;
    a, x, h, max, avg: real;

begin
  writeln('������������ ������ �2');
  writeln('������� ������, ������ ���155, ������� 141, �������: 2, 7, 2');
  
  { ������� 1 }
  writeln('������� 1');
  repeat
    write('������� ����������� ����� n �� 1 �� ', lmax, ', ����� ������� R: ');
    read(n);
  until (n > 0) and (n <= lmax);
  write('������� ����� a, x � h: ');
  read(a, x, h);
  
  for i := 1 to n do
    R[i] := 1.25*sin(3*a*x - i*h);
  
  writeln('������ R:');
  for i := 1 to n do
    write(R[i]:-8:3);
  writeln;
  
  { ������� 2 }
  f := 0;
  for i := n downto 1 do
    if R[i] < 0 then
      f := i;
  if f = 0 then
    writeln('� ������� ����������� ������������� ��������.')
  else
  begin
    writeln;
    writeln('������� 2');
    
    k := 0;
    for i := 1 to n do
      if (i <= f) or (abs(R[i]) < 0.3) then
      begin
        k := k + 1;
        R[k] := R[i]
      end;
    
    writeln('������ R'':');
    for i := 1 to k do
      write(R[i]:-8:3);
    writeln;
    if k = n then
      writeln('��� ��������');
    
    { ������� 3 }
    writeln;
    writeln('������� 3');
    nmax := 0;
    max := -1e308;
    for i := 1 to k do
      if R[i] > max then
      begin
        nmax := i;
        max := R[i]
      end;
    
    if nmax = k then
      writeln('�� ������� ����� ������� ��������������')
    else
    begin
      avg := 0;
      for i := nmax + 1 to k do
        avg := avg + R[i];
      avg := avg / (k - nmax);
      writeln('������� ��������������: ', avg:-14:5)
    end
  end;
end.