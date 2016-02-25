program lab6;
const lmax = 20;
type strings = array [1..lmax] of string;
var s, subs : strings; i, k, n, smallest, err : integer; reads, dots : string;

procedure filterSubstrings(k : integer; s : strings;
    var n : integer; var subs : strings);
var it, j, j1 : integer; cur : string;
begin
  n := 0;
  for it := 1 to k do begin
    cur := s[it];
    j := 1;
    j1 := 1;
    while j <= length(cur) do
      if ((cur[j] = '[') or (cur[j] = ']')) then begin
        if j <> 1 then begin
          n := n + 1;
          subs[n] := copy(cur, j1, j - j1);
        end; 
        while (j <= length(cur)) and ((cur[j] = '[') or (cur[j] = ']')) do
          j := j + 1;
        j1 := j;
      end else
        j := j + 1;
    if j <> j1 then begin
      n := n + 1;
      subs[n] := copy(cur, j1, j - j1);
    end;      
  end;  
end;

procedure findSmallest(n : integer; var subs : strings; var idx : integer);
var ml, i : integer;
begin
  ml := length(subs[1]); idx := 1;
  for i := 1 to n do
    if length(subs[i]) < ml then begin
      ml := length(subs[i]);
      idx := i
    end;
end;

procedure insertDots(var s : string);
var i : integer;
begin
  i := 1;
  while (i <= length(s)) and (not (s[i] in ['0'..'9'])) do
    inc(i);
  if i <= length(s) then
    insert('...', s, i+1);
end;

begin
  writeln('Лабораторная работа №6');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задания 10, 2, 10');
  
  writeln('Задание 1');
  repeat
    write('Введите натуральное число k: ');
    readln(reads);
    val(reads, k, err);
  until (err = 0) and (k > 0) and (k <= lmax);
  
  writeln('Введите строки:');
  for i := 1 to k do
    readln(s[i]);
    
  filterSubstrings(k, s, n, subs);
    
  if n = 0 then 
    writeln('Нет подстрок') 
  else begin
    { if n = k then
      writeln('Удалений не было.')
    else begin }
      writeln('Подстроки:');
      for i := 1 to n do
        writeln(subs[i]);
    { end; }
      
    writeln('Задание 2');
    findSmallest(n, subs, smallest);
    writeln('Наименьшая:');
    writeln(subs[smallest]);

    writeln('Задание 3');
    dots := subs[smallest];
    insertDots(dots);
    if dots = subs[smallest] then
      writeln('Цифр в найденной подстроке нет.')
    else begin
      writeln('Преобразованная:');
      writeln(dots);
    end
  end;
end.