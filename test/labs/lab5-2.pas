program lab5_prog2;
const lmax = 20;
var i, j, n, m : integer; nr, mr, min, max : real;
    a : array [1..lmax, 1..lmax] of real;
begin
  writeln('������������ ������ �5 ��������� 2');
  writeln('������� ������, ������ ���155, ������� 141, ������� �2 (��� 7)');
  
  repeat
    write('������� n: ');
    read(nr);
  until (nr > 0) and (nr <= lmax) and (nr = round(nr));
  n := round(nr);
  repeat
     write('������� m: ');
     read(mr);
  until (mr > 0) and (mr <= lmax) and (mr = round(mr));
  m := round(mr);
  
  writeln('������� �������:');
  for i := 1 to n do
      for j := 1 to m do
       read(a[i,j]);

  max := a[1,1];
  for i := 1 to n do begin
    min := maxint;
    for j := 1 to m do
      if abs(a[i,j]) < abs(min) then
        min := a[i,j];
    if min > max then
      max := min;
  end;

  writeln('D = ', max);
end.