program lab4_prog2;
const lmax = 20;
var B: array[1..lmax] of integer;
    k, i, t: integer;

begin
  writeln('������������ ������ �4 ��������� 2');
  writeln('������� ������, ������ ���155, ������� 141, ������� ������� 2');
  writeln('������� �2');
  
  repeat
    write('������� k, ����� ������� B, ����������� ����� �� 1 �� ', lmax, ': ');
    read(k);
  until (k >= 1) and (k <= lmax);
  
  writeln('������� ������:');
  for i := 1 to k do begin
    read(t);
    B[i] := 0;
    while t > 0 do begin
      B[i] := B[i] * 10 + (t mod 10);
      t := t div 10;
    end;
  end;
  
  writeln('������ B:');
  for i := 1 to k do
    write(B[i], ' ');
end.