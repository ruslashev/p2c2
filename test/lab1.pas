program lab1;
const lmax = 20;
var B, D, A: array[1..lmax] of real;
    i, k, n, nmax: integer;
    maximum, z, x, z1, z2, x1, y1: real;

begin
  writeln('������������ ������ �1');
  writeln('������� ������, ������ ���155, ������� 141, �������: 14, 2, 4');
  
  { ### ������� 1 }
  writeln('������� 1');
  repeat
    write('������� ����������� ����� k �� 1 �� ', lmax);
    write(', ����� ������� B: ');
    read(k);
  until (k > 0) and (k < lmax);
  
  writeln('������� ������ B �� ', k, ' ���������:');
  for i := 1 to k do
    read(B[i]);

  repeat
    write('������� ��������������� ����� x � z, ��� x <= z: ');
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
    writeln('��� ���������.')
  else
    writeln('�������� = ', maximum, ', ��� ������ � ������� = ', nmax);
  
  { ### ������� 2 }
  writeln;
  writeln('������� 2');
  repeat
    write('������� ����� z1 � z2, ��� z1 <= z2: ');
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
    writeln('�� ������� ��������� ������� D � A.')
  else
  begin
    writeln('������ D �� ', n, ' ���������');
    for i := 1 to n do
      write(D[i]:10:3, ' ');
    writeln;
    
    { ### ������� 3 }
    writeln;
    writeln('������� 3');
    repeat
      write('������� ����� x1 � y1, ��� x1 < y1: ');
      read(x1, y1);
    until (x1 < y1);
    
    for i := 1 to n do
      if (-y1 < D[i]) and (D[i] < -x1) then
        if (D[i] < 0) then begin
          A[i] := 0;
          write('������� ������� A[', i, '] �� ��������',
              ', ������� ��������� ����')
        end else
          A[i] := sqrt(D[i])
      else
        A[i] := D[i] / 3;
        
    writeln('������ A �� ', n, ' ���������');
    for i := 1 to n do
      write(A[i]:10:3);
    writeln;
  end;
end.
