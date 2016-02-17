program woop;

type nodeptr = ^node;
  node = record
    next: nodeptr;
    data: integer;
  end;

var root: ^node;

procedure print(var root: ^node);
var p: ^node;
begin
  p := root;
  while true do begin
    write(p^.data, ' -> ');
    if p^.next = nil then begin
      writeln('end');
      break;
    end;
    p := p^.next
  end;
end;
  
procedure make_queue(var root: ^node);
var
  t: integer;
  p, temp: ^node;
begin
  writeln('Введите целые числа для записи:');
  writeln('(-1 обозначает конец последовательности)');
  read(t);
  if t = -1 then
    root := nil
  else begin
    new(root);
    temp := root;
    repeat
      p := temp;
      new(temp);
      p^.next := temp;
      p^.data := t;
      read(t);
    until t = -1;
    p^.next := nil;
    dispose(temp);
  end;
end;

procedure process(var root: ^node);
var p, t: ^node; i, a1: integer;
begin
  p := root;
  i := 1;
  write('Введите число A1: ');
  read(a1);
  while true do begin
    if i mod 2 = 1 then begin
      t := p^.next;
      new(p^.next);
      p^.next^.next := t;
      p^.next^.data := a1;
    end;
    if p^.next = nil then
      break;
    p := p^.next;
    inc(i);
  end;
end;

procedure removals(var root: ^node);
var p, t: ^node; i, f, l: integer;
begin
  p := root;
  f := 0;
  i := 0;
  while true do begin
    inc(i);
    if p^.data mod 2 = 0 then begin
      if f = 0 then
        f := i;
      l := i;
    end;
    if p^.next = nil then
      break;
    p := p^.next;
  end;
  if f = 0 then
    writeln('В очереди не существуют чётные элементы')
  else if f = l then
    writeln('В очереди существует только один чётный элемент')
  else begin
    p := root;
    i := 0;
    while true do begin
      inc(i);
      if i = f then
        break;
      p := p^.next;
    end;
    while i <> l-1 do begin
      inc(i);
      t := p^.next^.next;
      dispose(p^.next);
      p^.next := t;
    end;
  end;
end;

begin
  make_queue(root);
  if root = nil then
    writeln('Пустая очередь')
  else begin
    print(root);
    process(root);
    print(root);
    removals(root);
    print(root);
  end;
end.
