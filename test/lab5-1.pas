program lab5_prog1;
var nr, mr : real; n, m : integer;

function lnf(k : integer) : real; 
begin
  for k := k downto 1 do
    result := result + ln(k);
end;

begin
  writeln('������������ ������ �5 ��������� 1');
  writeln('������� ������, ������ ���155, ������� 141, ������� �1 (��� 2)');
  repeat
    write('������� ����� ����� n � m, ��� m >= n >= 0: ');
    read(nr);
    read(mr);
  until (nr >= 0) and (mr >= nr)
      and (abs(nr) < maxint) and (abs(mr) < maxint)
      and (round(nr) = nr) and (round(mr) = mr);
  n := round(nr);
  m := round(mr);
  writeln('a = ', exp(lnf(m) - lnf(n) - lnf(m-n)));
end.