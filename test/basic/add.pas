program add;

var num1, num2, sum : integer;

begin
  write('input number 1:');
  readln(num1);
  writeln('input number 2:');
  readln(num2);
  sum := num1 + num2;
  writeln(sum);
  writeln(sum:10);
  writeln(sum:10:3);
  readln;
end.

