program p3;

const lmax = 40;

type
  tv = record
    manufacturer: record
      city, factory: String;
    end;
    name: String;
    params: record
      year, price: Integer;
      size: Real;
    end;
  end;

var
  records: array [1..lmax] of tv;
  nr, i, searchedIdx, maxYear, minPrice: Integer;
  f: File of tv;
  name: String;

begin
  writeln('Лабораторная работа №7');
  writeln('Акбашев Руслан, группа БИВ155, вариант 141, задание 3 (12)');

  repeat
    write('Имя файла для записи: ');
    readln(name);
  until CanCreateFile(name);
  
  assign(f, name);
  rewrite(f);
  
  repeat
    write('Количество записей: ');
    readln(nr);
  until nr in [1..lmax];
  
  writeln('Введите данные:');
  for i := 1 to nr do begin
    with records[i] do begin
      with manufacturer do begin
        write('Город изготовителя: ');
        readln(city);
        write('Завод: ');
        readln(factory);
      end;
      write('Название: ');
      readln(name);
      with params do begin
        repeat
          write('Год выпуска: ');
          readln(year);
        until (year > 1900) and (year <= 2015);

        repeat
          write('Цена: ');
          readln(price);
        until price > 0;

        repeat
          write('Размер экрана: ');
          readln(size);
        until size > 0;
        writeln;
      end;
    end;
    write(f, records[i]);
  end;
  close(f);
  
  searchedIdx := 0;
  maxYear := records[1].params.year;
  minPrice := 0;
  for i := 1 to nr do
    with records[i], params do
      if (year >= maxYear) or (maxYear = 0) then
        maxYear := year;
  for i := 1 to nr do
    with records[i], params do
      if ((price < minPrice) or (minPrice = 0)) and (year = maxYear) then begin
        minPrice := price;
        searchedIdx := i
      end;

  writeln('Искомый телевизор: ', records[searchedIdx].name);
end.