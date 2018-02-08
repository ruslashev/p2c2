*p2c2*: Pascal to C converter. Coursework for University.

Example dump (run `make` then execute `test.sh`. See also file `p2c2stdlib.h`):

```
bison -v -d -o parser.cc parser.y -Wno-other
parser.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]
flex -o lexer.cc lexer.l
g++ -c -o .lexer.o lexer.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -c -o .parser.o parser.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -c -o .main.o main.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -c -o .ast.o ast.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -c -o .utils.o utils.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -c -o .codegen.o codegen.cc -Wall -Wextra -Wpedantic -g -std=c++0x
g++ -o p2c2 .lexer.o .parser.o .main.o .ast.o .utils.o .codegen.o
test/basic/add.pas ==================================================================
{{{
  1 program add;
  2 
  3 type why = real;
  4      whyy = why;
  5 	 whyyy = whyy;
  6 
  7 var num1, num2, sum : integer;
  8     f : whyyy;
  9 
 10 begin
 11   write('input number 1:');
 12   readln(num1);
 13   writeln('input number 2:');
 14   readln(num2);
 15   sum := num1 + num2;
 16   writeln(sum);
 17   writeln(sum:10);
 18   writeln(sum:10:3);
 19   readln;
 20 end.
 21 
}}}
/* Program "add" */
#include "p2c2stdlib.h"

int num1, num2, sum;
float f;

int main()
{
  write(1, "input number 1:");
  readln(num1);
  writeln(1, "input number 2:");
  readln(num2);
  sum = num1 + num2;
  writeln(1, sum);
  writeln(1, width_format(sum, 10));
  writeln(1, full_format(sum, 10, 3));
  readln();
  return 0;
}

test/basic/bubble.pas ==================================================================
{{{
  1 (*****************************************************************************
  2  * A simple bubble sort program.  Reads integers, one per line, and prints   *
  3  * them out in sorted order.  Blows up if there are more than 49.            *
  4  *****************************************************************************)
  5 PROGRAM Sort(input, output);
  6     CONST
  7         (* Max array size. *)
  8         MaxElts = 50;
  9     TYPE
 10         (* Type of the element array. *)
 11         IntArrType = ARRAY [1..MaxElts] OF Integer;
 12 
 13     VAR
 14         (* Indexes, exchange temp, array size. *)
 15         i, j, tmp, size: integer;
 16 
 17         (* Array of ints *)
 18         arr: IntArrType;
 19 
 20     (* Read in the integers. *)
 21     PROCEDURE ReadArr(VAR size: Integer; VAR a: IntArrType);
 22         BEGIN
 23             size := 1;
 24             WHILE NOT eof DO BEGIN
 25                 readln(a[size]);
 26                 IF NOT eof THEN
 27                     size := size + 1
 28             END
 29         END;
 30 
 31     BEGIN
 32         (* Read *)
 33         ReadArr(size, arr);
 34 
 35         (* Sort using bubble sort. *)
 36         FOR i := size - 1 DOWNTO 1 DO
 37             FOR j := 1 TO i DO
 38                 IF arr[j] > arr[j + 1] THEN BEGIN
 39                     tmp := arr[j];
 40                     arr[j] := arr[j + 1];
 41                     arr[j + 1] := tmp;
 42                 END;
 43 
 44         (* Print. *)
 45         FOR i := 1 TO size DO
 46             writeln(arr[i])
 47     END.
}}}
/* Program "Sort" */
#include "p2c2stdlib.h"

const int MaxElts = 50;

int i, j, tmp, size;
array<1,MaxElts,int> arr;

void ReadArr(int &size, array<1,MaxElts,int> &a)
{
  size = 1;
  while (!(eof))
  {
    readln(a[size]);
    if (!(eof))
      size = size + 1;
  }
}
int main()
{
  ReadArr(size, arr);
  for (i = size - 1; i >= 1; i--)
    for (j = 1; j <= i; j++)
      if (arr[j] > arr[j + 1])
      {
        tmp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = tmp;
      }
  for (i = 1; i <= size; i++)
    writeln(1, arr[i]);
  return 0;
}

test/basic/hw.pas ==================================================================
{{{
  1 program hw;
  2 begin
  3   write('Hello, World!');
  4   readln;
  5 end.
  6 
}}}
/* Program "hw" */
#include "p2c2stdlib.h"

int main()
{
  write(1, "Hello, World!");
  readln();
  return 0;
}

test/basic/input.pas ==================================================================
{{{
  1 program ye(wyt, what);
  2 label 420, 2517;
  3 const im_givin_up = -4; on_trying = +20; to_sell_you_things = 'that you aint buying';
  4       coat = 'steel'; lmax = 20;
  5 type
  6   natural = 0..maxint;
  7   count = integer;
  8   range = integer;
  9   angle = 0..360;
 10   colour = (red, yellow, green, blue);
 11   sex = (male, female);
 12   year = 1900..1999;
 13   asdf = -10..+10;
 14   wdydt = '0'..'9';
 15   yyk = red..green;
 16   shape = (triangle, rectangle, circle);
 17   punchedcard = array [1..80] of char;
 18   wake_me_up_inside = array [(the, ride, never, ends)] of (how, can, you, see, into, my, eyes);
 19   win = array [Boolean] of colour;
 20   size = 1..20;
 21   send = array [Boolean] of array [1..10] of array [size] of real;
 22   help = packed array [Boolean] of array [1..10, size] of real;
 23   charsequence = string;
 24   polar = record
 25             r : real;
 26             theta: angle;
 27             year: 0..2000;
 28             name, firstname: string;
 29 			(*
 30             case shape of
 31               triangle :
 32                 (side : real ; inclination, angle1, angle2 : angle);
 33               rectangle :
 34                 (side1, side2 : real; sadfj : angle);
 35               circle :
 36                 (diameter : real);
 37 				*)
 38           end;
 39   indextype = 1..lmax;
 40   masti = set of (club, diamond, heart, spade);
 41   vector = array [indextype] of real;
 42   person = ^ persondetails;
 43   persondetails = record
 44                     name, firstname: charsequence;
 45                     age : natural;
 46                     father, child, sibling : person;
 47 					(*
 48                     case married : Boolean of
 49                       true : (Gal : string);
 50                       false : ( );
 51 					  *)
 52                   end;
 53   whyyy = 1..lmax;
 54   whyy = whyyy;
 55   why = array [whyy] of real;
 56 FileOfInteger = file of integer;
 57 
 58 var
 59 	(*
 60 	wat : natural;
 61 	test : count;
 62 	yuo : angle;
 63 	col : colour;
 64 	y : year;
 65 	s : asdf;
 66 	hi : wdydt;
 67 	waddup : yyk;
 68 	sh : shape;
 69 	p : punchedcard;
 70 	wake_me_up : wake_me_up_inside;
 71 	heh : win;
 72 	sz : size;
 73 	psl : send;
 74 	pls : help;
 75 	what : charsequence;
 76 	ohshit : polar;
 77 	idx : indextype;
 78 	dude : masti;
 79 	depedns : vector;
 80 	*)
 81 	gyu : person;
 82 	// bio : persondetails;
 83 	// f : fileofinteger;
 84 
 85 begin
 86 	writeln('asdf');
 87 	readln;
 88 end.
 89 
}}}
/* Program "ye" */
#include "p2c2stdlib.h"

const int im_givin_up = -4, on_trying = +20, lmax = 20;
const char *to_sell_you_things = "that you aint buying", *coat = "steel";

struct rec1 { string name, firstname; subrange<0,maxint> age; rec1 *father, *child, *sibling; } *gyu;

int main()
{
  writeln(1, "asdf");
  readln();
  return 0;
}

test/basic/quicksort.pas ==================================================================
{{{
  1 {*****************************************************************************
  2  * A Pascal quicksort.
  3  *****************************************************************************}
  4 
  5 
  6 PROGRAM Sort(input, output);
  7     CONST
  8         { Max array size. }
  9         MaxElts = 50;
 10     TYPE 
 11         { Type of the element array. }
 12         IntArrType = ARRAY [1..MaxElts] OF Integer;
 13 
 14     VAR
 15 
 16         { Indexes, exchange temp, array size. }
 17 
 18         i, j, tmp, size: integer;
 19 
 20         { Array of ints }
 21         arr: IntArrType;
 22 
 23     { Read in the integers. }
 24     PROCEDURE ReadArr(VAR size: Integer; VAR a: IntArrType);
 25         BEGIN
 26             size := 1;
 27             WHILE NOT eof DO BEGIN
 28                 readln(a[size]);
 29                 IF NOT eof THEN 
 30                     size := size + 1
 31             END
 32         END;
 33 
 34     { Use quicksort to sort the array of integers. }
 35     PROCEDURE Quicksort(size: Integer; VAR arr: IntArrType);
 36         { This does the actual work of the quicksort.  It takes the
 37           parameters which define the range of the array to work on,
 38           and references the array as a global. }
 39         PROCEDURE QuicksortRecur(start, stop: integer);
 40             VAR
 41                 m: integer;
 42 
 43                 { The location separating the high and low parts. }
 44                 splitpt: integer;
 45 
 46             { The quicksort split algorithm.  Takes the range, and
 47               returns the split point. }
 48             FUNCTION Split(start, stop: integer): integer;
 49                 VAR
 50                     left, right: integer;       { Scan pointers. }
 51                     pivot: integer;             { Pivot value. }
 52 
 53                 { Interchange the parameters. }
 54                 PROCEDURE swap(VAR a, b: integer);
 55                     VAR
 56                         t: integer;
 57                     BEGIN
 58                         t := a;
 59                         a := b;
 60                         b := t
 61                     END;
 62 
 63                 BEGIN { Split }
 64                     { Set up the pointers for the hight and low sections, and
 65                       get the pivot value. }
 66                     pivot := arr[start];
 67                     left := start + 1;
 68                     right := stop;
 69 
 70                     { Look for pairs out of place and swap 'em. }
 71                     WHILE left <= right DO BEGIN
 72                         WHILE (left <= stop) AND (arr[left] < pivot) DO
 73                             left := left + 1;
 74                         WHILE (right > start) AND (arr[right] >= pivot) DO
 75                             right := right - 1;
 76                         IF left < right THEN 
 77                             swap(arr[left], arr[right]);
 78                     END;
 79 
 80                     { Put the pivot between the halves. }
 81                     swap(arr[start], arr[right]);
 82 
 83                     { This is how you return function values in pascal.
 84                       Yeccch. }
 85                     Split := right
 86                 END;
 87 
 88             BEGIN { QuicksortRecur }
 89                 { If there's anything to do... }
 90                 IF start < stop THEN BEGIN
 91                     splitpt := Split(start, stop);
 92                     QuicksortRecur(start, splitpt-1);
 93                     QuicksortRecur(splitpt+1, stop);
 94                 END
 95             END;
 96 
 97         BEGIN { Quicksort }
 98             QuicksortRecur(1, size)
 99         END;
100 
101     BEGIN
102         { Read }
103         ReadArr(size, arr);
104 
105         { Sort the contents. }
106         Quicksort(size, arr);
107 
108         { Print. }
109         FOR i := 1 TO size DO
110             writeln(arr[i])
111     END.
112 
}}}
Function definitions inside functions are not supported in C
test/basic/records.pas ==================================================================
{{{
  1 program records_test;
  2 
  3 type date =
  4 record
  5 	year : 0..2000;
  6 	month : 1..12;
  7 	day : 1..31
  8 end;
  9 
 10 person =
 11 record
 12 	name, firstname : string;
 13 	age : 0..99;
 14 	case married : Boolean of
 15 		true : (Spousesname : string);
 16 		false : ( )
 17 end;
 18 
 19 what =
 20 record
 21 	x, y: real;
 22 	area: real;
 23 	case shape of
 24 		triangle: (side: real ; inclination, angle1, angle2: angle);
 25 		rectangle: (side1, side2: real ; skew: angle);
 26 		circle: (diameter: real);
 27 end;
 28 
 29 begin
 30 end.
 31 
}}}
/* Program "records_test" */
#include "p2c2stdlib.h"

int main()
{
  return 0;
}

test/basic/tri.pas ==================================================================
{{{
  1 program TRI-HEAP;
  2 
  3    const N = 10;   
  4    var TABLE: array[1..N] of INTEGER;
  5        TEMP: INTEGER;
  6 
  7    procedure AJUSTE(var I,N: INTEGER);
  8       var TEMP,J: INTEGER;
  9           TERMINE: BOOLEAN;
 10    begin
 11       TEMP :=    TABLE[I];
 12       J    :=    2*I;
 13       TERMINE := FALSE;
 14  
 15       while (J<=N) and not TERMINE do
 16       begin
 17          if (J<N) and (TABLE[J]<TABLE[J+1]) then J := J+1;
 18          if TEMP>TABLE[J] then
 19 	 TERMINE := TRUE
 20          else
 21 	 begin
 22             TABLE[J/2] := TABLE[J];
 23             J := 2*J;
 24 	 end;
 25       end;
 26 
 27       TABLE[J/2] := TEMP;
 28 
 29    end;
 30 
 31    procedure CONSTRUIRE-HEAP;
 32    begin
 33       for I := N/2 downto 1 do AJUSTE(I,N);
 34    end;
 35 
 36 begin
 37 
 38    for I := 1 to N do READ(TABLE[I]);
 39 
 40    CONSTRUIRE-HEAP;
 41 
 42    for I := N-1 downto 1 do
 43    begin
 44       TEMP := TABLE[I+1];
 45       TABLE[I+1] := TABLE[1];
 46       TABLE[1] := TEMP;
 47       AJUSTE(1,I);
 48    end;
 49 
 50    for I := 1 to N do WRITE(TABLE[I]);
 51 
 52 end.
}}}
/* Program "TRI-HEAP" */
#include "p2c2stdlib.h"

const int N = 10;

array<1,N,int> TABLE;
int TEMP;

void AJUSTE(int &I, int &N)
{
  int TEMP, J;
  bool TERMINE;

  TEMP = TABLE[I];
  J = 2 * I;
  TERMINE = FALSE;
  while ((J <= N) && !(TERMINE))
  {
    if ((J < N) && (TABLE[J] < TABLE[J + 1]))
      J = J + 1;
    if (TEMP > TABLE[J])
      TERMINE = TRUE;
    else
    {
      TABLE[J / 2] = TABLE[J];
      J = 2 * J;
    }
  }
  TABLE[J / 2] = TEMP;
}
void CONSTRUIRE-HEAP()
{
  for (I = N / 2; I >= 1; I--)
    AJUSTE(I, N);
}
int main()
{
  for (I = 1; I <= N; I++)
    READ(TABLE[I]);
  CONSTRUIRE-HEAP();
  for (I = N-1; I >= 1; I--)
  {
    TEMP = TABLE[I + 1];
    TABLE[I + 1] = TABLE[1];
    TABLE[1] = TEMP;
    AJUSTE(1, I);
  }
  for (I = 1; I <= N; I++)
    WRITE(TABLE[I]);
  return 0;
}

test/basic/what.pas ==================================================================
{{{
  1 program ples;
  2 
  3 var a : (red, gren, ble);
  4     b : (red, gren, ble);
  5 
  6 begin
  7 
  8 end.
  9 
}}}
/* Program "ples" */
#include "p2c2stdlib.h"

enum en1 { red = 0; ; gren; ble } a;
en1 b;

int main()
{
  return 0;
}

test/labs/lab1.pas ==================================================================
{{{
  1 program lab1;
  2 const lmax = 20;
  3 var B, D, A: array[1..lmax] of real;
  4     i, k, n, nmax: integer;
  5     maximum, z, x, z1, z2, x1, y1: real;
  6 
  7 begin
  8   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹1');
  9   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ: 14, 2, 4');
 10   
 11   { ### Çàäàíèå 1 }
 12   writeln('Çàäàíèå 1');
 13   repeat
 14     write('Ââåäèòå íàòóðàëüíîå ÷èñëî k îò 1 äî ', lmax);
 15     write(', äëèíó ìàññèâà B: ');
 16     read(k);
 17   until (k > 0) and (k < lmax);
 18   
 19   writeln('Ââåäèòå ìàññèâ B èç ', k, ' ýëåìåíòîâ:');
 20   for i := 1 to k do
 21     read(B[i]);
 22 
 23   repeat
 24     write('Ââåäèòå íåïîëîæèòåëüíûå ÷èñëà x è z, ãäå x <= z: ');
 25     read(x, z);
 26   until (x <= 0) and (z <= 0) and (z >= x);
 27   
 28   maximum := 0;
 29   nmax := 0;
 30   for i := 1 to k do
 31     if (abs(B[i]) >= abs(maximum)) and
 32        (-z <= abs(B[i])) and
 33        (abs(B[i]) <= -x) then
 34     begin
 35       maximum := B[i];
 36       nmax := i;
 37     end;
 38     
 39   if nmax = 0 then
 40     writeln('Íåò ìàêñèìóìà.')
 41   else
 42     writeln('Ìàêñèìóì = ', maximum, ', åãî èíäåêñ â ìàññèâå = ', nmax);
 43   
 44   { ### Çàäàíèå 2 }
 45   writeln;
 46   writeln('Çàäàíèå 2');
 47   repeat
 48     write('Ââåäèòå ÷èñëà z1 è z2, ãäå z1 <= z2: ');
 49     read(z1, z2);
 50   until (z1 <= z2);
 51   
 52   n := 0;
 53   for i := 1 to k do
 54     if (z1 <= B[i]) and (B[i] <= z2) then
 55     begin
 56       n := n + 1;
 57       D[n] := B[i];
 58     end;
 59     
 60   if n = 0 then
 61     writeln('Íå óäàëîñü ñîñòàâèòü ìàññèâû D è A.')
 62   else
 63   begin
 64     writeln('Ìàññèâ D èç ', n, ' ýëåìåíòîâ');
 65     for i := 1 to n do
 66       write(D[i]:10:3, ' ');
 67     writeln;
 68     
 69     { ### Çàäàíèå 3 }
 70     writeln;
 71     writeln('Çàäàíèå 3');
 72     repeat
 73       write('Ââåäèòå ÷èñëà x1 è y1, ãäå x1 < y1: ');
 74       read(x1, y1);
 75     until (x1 < y1);
 76     
 77     for i := 1 to n do
 78       if (-y1 < D[i]) and (D[i] < -x1) then
 79         if (D[i] < 0) then begin
 80           A[i] := 0;
 81           write('Ýëåìåíò ìàññèâà A[', i, '] íå îïðåäåë¸í',
 82               ', ïîýòîìó ñ÷èòàåòñÿ íóë¸ì')
 83         end else
 84           A[i] := sqrt(D[i])
 85       else
 86         A[i] := D[i] / 3;
 87         
 88     writeln('Ìàññèâ A èç ', n, ' ýëåìåíòîâ');
 89     for i := 1 to n do
 90       write(A[i]:10:3);
 91     writeln;
 92   end;
 93 end.
}}}
/* Program "lab1" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,float> B, D, A;
int i, k, n, nmax;
float maximum, z, x, z1, z2, x1, y1;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹1");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ: 14, 2, 4");
  writeln(1, "Çàäàíèå 1");
  do
  {
    write(2, "Ââåäèòå íàòóðàëüíîå ÷èñëî k îò 1 äî ", lmax);
    write(1, ", äëèíó ìàññèâà B: ");
    read(k);
  } while (!((k > 0) && (k < lmax)));
  writeln(3, "Ââåäèòå ìàññèâ B èç ", k, " ýëåìåíòîâ:");
  for (i = 1; i <= k; i++)
    read(B[i]);
  do
  {
    write(1, "Ââåäèòå íåïîëîæèòåëüíûå ÷èñëà x è z, ãäå x <= z: ");
    read(x, z);
  } while (!((x <= 0) && (z <= 0) && (z >= x)));
  maximum = 0;
  nmax = 0;
  for (i = 1; i <= k; i++)
    if ((abs(B[i]) >= abs(maximum)) && (-z <= abs(B[i])) && (abs(B[i]) <= -x))
    {
      maximum = B[i];
      nmax = i;
    }
  if (nmax == 0)
    writeln(1, "Íåò ìàêñèìóìà.");
  else
    writeln(4, "Ìàêñèìóì = ", maximum, ", åãî èíäåêñ â ìàññèâå = ", nmax);
  writeln();
  writeln(1, "Çàäàíèå 2");
  do
  {
    write(1, "Ââåäèòå ÷èñëà z1 è z2, ãäå z1 <= z2: ");
    read(z1, z2);
  } while (!((z1 <= z2)));
  n = 0;
  for (i = 1; i <= k; i++)
    if ((z1 <= B[i]) && (B[i] <= z2))
    {
      n = n + 1;
      D[n] = B[i];
    }
  if (n == 0)
    writeln(1, "Íå óäàëîñü ñîñòàâèòü ìàññèâû D è A.");
  else
  {
    writeln(3, "Ìàññèâ D èç ", n, " ýëåìåíòîâ");
    for (i = 1; i <= n; i++)
      write(2, full_format(D[i], 10, 3), " ");
    writeln();
    writeln();
    writeln(1, "Çàäàíèå 3");
    do
    {
      write(1, "Ââåäèòå ÷èñëà x1 è y1, ãäå x1 < y1: ");
      read(x1, y1);
    } while (!((x1 < y1)));
    for (i = 1; i <= n; i++)
      if ((-y1 < D[i]) && (D[i] < -x1))
        if ((D[i] < 0))
        {
          A[i] = 0;
          write(4, "Ýëåìåíò ìàññèâà A[", i, "] íå îïðåäåë¸í", ", ïîýòîìó ñ÷èòàåòñÿ íóë¸ì");
        }
        else
          A[i] = sqrt(D[i]);
      else
        A[i] = D[i] / 3;
    writeln(3, "Ìàññèâ A èç ", n, " ýëåìåíòîâ");
    for (i = 1; i <= n; i++)
      write(1, full_format(A[i], 10, 3));
    writeln();
  }
  return 0;
}

test/labs/lab2.pas ==================================================================
{{{
  1 program lab2;
  2 const lmax = 20;
  3 var R: array[1..lmax] of real;
  4     i, n, k, f, nmax: integer;
  5     a, x, h, max, avg: real;
  6 
  7 begin
  8   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹2');
  9   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ: 2, 7, 2');
 10   
 11   { Çàäàíèå 1 }
 12   writeln('Çàäàíèå 1');
 13   repeat
 14     write('Ââåäèòå íàòóðàëüíîå ÷èñëî n îò 1 äî ', lmax, ', äëèíó ìàññèâà R: ');
 15     read(n);
 16   until (n > 0) and (n <= lmax);
 17   write('Ââåäèòå ÷èñëà a, x è h: ');
 18   read(a, x, h);
 19   
 20   for i := 1 to n do
 21     R[i] := 1.25*sin(3*a*x - i*h);
 22   
 23   writeln('Ìàññèâ R:');
 24   for i := 1 to n do
 25     write(R[i]:-8:3);
 26   writeln;
 27   
 28   { Çàäàíèå 2 }
 29   f := 0;
 30   for i := n downto 1 do
 31     if R[i] < 0 then
 32       f := i;
 33   if f = 0 then
 34     writeln('Â ìàññèâå îòñóòñòâóþò îòðèöàòåëüíûå ýëåìåíòû.')
 35   else
 36   begin
 37     writeln;
 38     writeln('Çàäàíèå 2');
 39     
 40     k := 0;
 41     for i := 1 to n do
 42       if (i <= f) or (abs(R[i]) < 0.3) then
 43       begin
 44         k := k + 1;
 45         R[k] := R[i]
 46       end;
 47     
 48     writeln('Ìàññèâ R'':');
 49     for i := 1 to k do
 50       write(R[i]:-8:3);
 51     writeln;
 52     if k = n then
 53       writeln('Íåò óäàëåíèé');
 54     
 55     { Çàäàíèå 3 }
 56     writeln;
 57     writeln('Çàäàíèå 3');
 58     nmax := 0;
 59     max := -1e308;
 60     for i := 1 to k do
 61       if R[i] > max then
 62       begin
 63         nmax := i;
 64         max := R[i]
 65       end;
 66     
 67     if nmax = k then
 68       writeln('Íå óäàëîñü íàéòè ñðåäíåå àðèôìåòè÷åñêîå')
 69     else
 70     begin
 71       avg := 0;
 72       for i := nmax + 1 to k do
 73         avg := avg + R[i];
 74       avg := avg / (k - nmax);
 75       writeln('Ñðåäíåå àðèôìåòè÷åñêîå: ', avg:-14:5)
 76     end
 77   end;
 78 end.
}}}
/* Program "lab2" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,float> R;
int i, n, k, f, nmax;
float a, x, h, max, avg;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹2");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ: 2, 7, 2");
  writeln(1, "Çàäàíèå 1");
  do
  {
    write(3, "Ââåäèòå íàòóðàëüíîå ÷èñëî n îò 1 äî ", lmax, ", äëèíó ìàññèâà R: ");
    read(n);
  } while (!((n > 0) && (n <= lmax)));
  write(1, "Ââåäèòå ÷èñëà a, x è h: ");
  read(a, x, h);
  for (i = 1; i <= n; i++)
    R[i] = 1.25 * sin(3 * a * x - i * h);
  writeln(1, "Ìàññèâ R:");
  for (i = 1; i <= n; i++)
    write(1, full_format(R[i], -8, 3));
  writeln();
  f = 0;
  for (i = n; i >= 1; i--)
    if (R[i] < 0)
      f = i;
  if (f == 0)
    writeln(1, "Â ìàññèâå îòñóòñòâóþò îòðèöàòåëüíûå ýëåìåíòû.");
  else
  {
    writeln();
    writeln(1, "Çàäàíèå 2");
    k = 0;
    for (i = 1; i <= n; i++)
      if ((i <= f) || (abs(R[i]) < 0.3))
      {
        k = k + 1;
        R[k] = R[i];
      }
    writeln(1, "Ìàññèâ R'':");
    for (i = 1; i <= k; i++)
      write(1, full_format(R[i], -8, 3));
    writeln();
    if (k == n)
      writeln(1, "Íåò óäàëåíèé");
    writeln();
    writeln(1, "Çàäàíèå 3");
    nmax = 0;
    max = -1e308;
    for (i = 1; i <= k; i++)
      if (R[i] > max)
      {
        nmax = i;
        max = R[i];
      }
    if (nmax == k)
      writeln(1, "Íå óäàëîñü íàéòè ñðåäíåå àðèôìåòè÷åñêîå");
    else
    {
      avg = 0;
      for (i = nmax + 1; i <= k; i++)
        avg = avg + R[i];
      avg = avg / (k - nmax);
      writeln(2, "Ñðåäíåå àðèôìåòè÷åñêîå: ", full_format(avg, -14, 5));
    }
  }
  return 0;
}

test/labs/lab3-1.pas ==================================================================
{{{
  1 program lab3_prog1;
  2 var i: integer;
  3     s, prev, cur, eps, x: real;
  4 
  5 begin
  6   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹3 ïðîãðàììà 1');
  7   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 6');
  8   writeln('Çàäàíèå ¹1');
  9   
 10   repeat
 11     write('Ââåäèòå âåùåñòâåííîå ÷èñëî eps áîëüøåå íóëÿ: ');
 12     read(eps);
 13   until (eps > 0);
 14   repeat
 15     write('Ââåäèòå ÷èñëî x òàêæå áîëüøåå íóëÿ: ');
 16     read(x);
 17   until (x > 0);
 18   
 19   prev := (x - 1)/x;
 20   cur := sqr(x - 1)/(2*sqr(x));
 21   s := prev + cur;
 22   i := 2;
 23   while abs(cur) > eps do
 24   begin
 25     prev := cur;
 26     cur := prev * (i - 1)*(x - 1)/(i*x);
 27     s := s + cur;
 28     i := i + 1
 29   end;
 30   writeln('Ïîëó÷åííîå çíà÷åíèå ïî ôîðìóëå: ', s);
 31   writeln('Òî÷íîå çíà÷åíèå: ln(', x, ') = ', ln(x));
 32   writeln('Ñðàâíåíèå: |ln(x)-s| = ', abs(ln(x)-s));
 33   writeln('Îòëè÷èå â ', 100*(1-s/ln(x)) : 7 : 6, '%');
 34 end.
}}}
/* Program "lab3_prog1" */
#include "p2c2stdlib.h"

int i;
float s, prev, cur, eps, x;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹3 ïðîãðàììà 1");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 6");
  writeln(1, "Çàäàíèå ¹1");
  do
  {
    write(1, "Ââåäèòå âåùåñòâåííîå ÷èñëî eps áîëüøåå íóëÿ: ");
    read(eps);
  } while (!((eps > 0)));
  do
  {
    write(1, "Ââåäèòå ÷èñëî x òàêæå áîëüøåå íóëÿ: ");
    read(x);
  } while (!((x > 0)));
  prev = (x - 1) / x;
  cur = sqr(x - 1) / (2 * sqr(x));
  s = prev + cur;
  i = 2;
  while (abs(cur) > eps)
  {
    prev = cur;
    cur = prev * (i - 1) * (x - 1) / (i * x);
    s = s + cur;
    i = i + 1;
  }
  writeln(2, "Ïîëó÷åííîå çíà÷åíèå ïî ôîðìóëå: ", s);
  writeln(4, "Òî÷íîå çíà÷åíèå: ln(", x, ") = ", ln(x));
  writeln(2, "Ñðàâíåíèå: |ln(x)-s| = ", abs(ln(x) - s));
  writeln(3, "Îòëè÷èå â ", full_format(100 * (1 - s / ln(x)), 7, 6), "%");
  return 0;
}

test/labs/lab3-2.pas ==================================================================
{{{
  1 program lab3_prog2;
  2 const lmax = 20;
  3 var A: array[1..lmax, 1..lmax] of integer;
  4     B: array[1..lmax] of array[1..lmax] of integer;
  5     i, j, n, t, nodd: integer;
  6 
  7 begin
  8   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹3 ïðîãðàììà 2');
  9   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíòû çàäàíèé 7 è 2');
 10   writeln('Çàäàíèå ¹2');
 11   
 12   repeat
 13     write('Ââåäèòå ðàçìåð ìàòðèöû A, íàòóðàëüíîå ÷èñëî n îò 3 äî ', lmax, ': ');
 14     read(n);
 15   until (n >= 3) and (n <= lmax);
 16   
 17   writeln('Ââåäèòå ìàòðèöó:');
 18   for i := 1 to n do
 19     for j := 1 to n do
 20       read(A[i,j]);
 21 
 22   for i := 1 to n-1 do
 23     for j := i+1 to n do
 24       if A[1,i] > A[1,j] then
 25       begin
 26         t := A[1,i];
 27         A[1,i] := A[1,j];
 28         A[1,j] := t
 29       end;
 30   
 31   writeln('Òðè ìèíèìàëüíûõ ýëåìåíòà íà ïåðâîé ñòðîêå: ',
 32       A[1,1], ' ', A[1,2], ' ', A[1,3]);
 33   
 34   writeln('Çàäàíèå ¹3');
 35   nodd := 0;
 36   for i := 1 to n do
 37     if A[i, n-i+1] mod 2 <> 0 then
 38       nodd := nodd + 1;
 39   
 40   if nodd = 0 then
 41     writeln('Íåò íå÷¸òíûõ ýëåìåíòîâ')
 42   else
 43     writeln('Íå÷¸òíûõ ýëåìåíòîâ íà ïîáî÷íîé äèàãîíàëè: ', nodd);
 44 end.
}}}
/* Program "lab3_prog2" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,array<1,lmax,int>> A;
array<1,lmax,array<1,lmax,int>> B;
int i, j, n, t, nodd;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹3 ïðîãðàììà 2");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíòû çàäàíèé 7 è 2");
  writeln(1, "Çàäàíèå ¹2");
  do
  {
    write(3, "Ââåäèòå ðàçìåð ìàòðèöû A, íàòóðàëüíîå ÷èñëî n îò 3 äî ", lmax, ": ");
    read(n);
  } while (!((n >= 3) && (n <= lmax)));
  writeln(1, "Ââåäèòå ìàòðèöó:");
  for (i = 1; i <= n; i++)
    for (j = 1; j <= n; j++)
      read(A[i][j]);
  for (i = 1; i <= n-1; i++)
    for (j = i + 1; j <= n; j++)
      if (A[1][i] > A[1][j])
      {
        t = A[1][i];
        A[1][i] = A[1][j];
        A[1][j] = t;
      }
  writeln(6, "Òðè ìèíèìàëüíûõ ýëåìåíòà íà ïåðâîé ñòðîêå: ", A[1][1], " ", A[1][2], " ", A[1][3]);
  writeln(1, "Çàäàíèå ¹3");
  nodd = 0;
  for (i = 1; i <= n; i++)
    if (A[i][n-i + 1] % 2 != 0)
      nodd = nodd + 1;
  if (nodd == 0)
    writeln(1, "Íåò íå÷¸òíûõ ýëåìåíòîâ");
  else
    writeln(2, "Íå÷¸òíûõ ýëåìåíòîâ íà ïîáî÷íîé äèàãîíàëè: ", nodd);
  return 0;
}

test/labs/lab4-1.pas ==================================================================
{{{
  1 program lab4_prog1;
  2 const lmax = 20;
  3 var A: array[1..lmax, 1..lmax] of integer;
  4     n, m, i, j, fz, lnz, t: integer;
  5     flag : boolean;
  6 
  7 begin
  8   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹4 ïðîãðàììà 1');
  9   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 6');
 10   writeln('Çàäàíèå ¹1');
 11   
 12   repeat
 13     write('Ââåäèòå ðàçìåð n ìàòðèöû A[1:n,1:m], íàòóðàëüíîå ÷èñëî 2 äî ',
 14         lmax, ': ');
 15     read(n);
 16   until (n >= 2) and (n <= lmax);
 17   repeat
 18     write('Ââåäèòå ðàçìåð m, íàòóðàëüíîå ÷èñëî 1 äî ', lmax, ': ');
 19     read(m);
 20   until (m >= 1) and (m <= lmax);
 21   
 22   writeln('Ââåäèòå ìàòðèöó:');
 23   for i := 1 to n do
 24     for j := 1 to m do
 25       read(A[i,j]);
 26   
 27   fz := 0;
 28   i := 1;
 29   flag := false;
 30   while (i <= n) and (flag = false) do begin
 31     for j := 1 to m do
 32       if A[i,j] = 0 then begin
 33         fz := i;
 34         flag := true;
 35       end;
 36     i := i + 1;
 37   end;
 38   lnz := n;
 39   flag := false;
 40   while (lnz >= 1) and (flag = false) do begin
 41     flag := true;
 42     for j := 1 to m do
 43       if A[lnz,j] = 0 then
 44         flag := false;
 45     if not flag then lnz := lnz - 1;
 46   end;
 47   
 48   if fz = 0 then
 49     writeln('Íåò ñòðîêè ñ íóëåâûì ýëåìåíòîì')
 50   else if lnz = 0 then
 51     writeln('Íåò ñòðîê íå ñîäåðæàùèõ íè îäíîãî íóëÿ')
 52   else begin
 53     for j := 1 to m do begin
 54       t := A[fz,j];
 55       A[fz,j] := A[lnz,j];
 56       A[lnz,j] := t
 57     end;
 58     
 59     writeln('Ìàòðèöà A:');
 60     for i := 1 to n do begin
 61       for j := 1 to m do
 62         write(A[i,j]:3);
 63       writeln
 64     end
 65   end;
 66 end.
}}}
/* Program "lab4_prog1" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,array<1,lmax,int>> A;
int n, m, i, j, fz, lnz, t;
bool flag;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹4 ïðîãðàììà 1");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 6");
  writeln(1, "Çàäàíèå ¹1");
  do
  {
    write(3, "Ââåäèòå ðàçìåð n ìàòðèöû A[1:n,1:m], íàòóðàëüíîå ÷èñëî 2 äî ", lmax, ": ");
    read(n);
  } while (!((n >= 2) && (n <= lmax)));
  do
  {
    write(3, "Ââåäèòå ðàçìåð m, íàòóðàëüíîå ÷èñëî 1 äî ", lmax, ": ");
    read(m);
  } while (!((m >= 1) && (m <= lmax)));
  writeln(1, "Ââåäèòå ìàòðèöó:");
  for (i = 1; i <= n; i++)
    for (j = 1; j <= m; j++)
      read(A[i][j]);
  fz = 0;
  i = 1;
  flag = false;
  while ((i <= n) && (flag == false))
  {
    for (j = 1; j <= m; j++)
      if (A[i][j] == 0)
      {
        fz = i;
        flag = true;
      }
    i = i + 1;
  }
  lnz = n;
  flag = false;
  while ((lnz >= 1) && (flag == false))
  {
    flag = true;
    for (j = 1; j <= m; j++)
      if (A[lnz][j] == 0)
        flag = false;
    if (!(flag))
      lnz = lnz - 1;
  }
  if (fz == 0)
    writeln(1, "Íåò ñòðîêè ñ íóëåâûì ýëåìåíòîì");
  else
    if (lnz == 0)
      writeln(1, "Íåò ñòðîê íå ñîäåðæàùèõ íè îäíîãî íóëÿ");
    else
    {
      for (j = 1; j <= m; j++)
      {
        t = A[fz][j];
        A[fz][j] = A[lnz][j];
        A[lnz][j] = t;
      }
      writeln(1, "Ìàòðèöà A:");
      for (i = 1; i <= n; i++)
      {
        for (j = 1; j <= m; j++)
          write(1, width_format(A[i][j], 3));
        writeln();
      }
    }
  return 0;
}

test/labs/lab4-2.pas ==================================================================
{{{
  1 program lab4_prog2;
  2 const lmax = 20;
  3 var B: array[1..lmax] of integer;
  4     k, i, t: integer;
  5 
  6 begin
  7   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹4 ïðîãðàììà 2');
  8   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 2');
  9   writeln('Çàäàíèå ¹2');
 10   
 11   repeat
 12     write('Ââåäèòå k, äëèíó ìàññèâà B, íàòóðàëüíîå ÷èñëî îò 1 äî ', lmax, ': ');
 13     read(k);
 14   until (k >= 1) and (k <= lmax);
 15   
 16   writeln('Ââåäèòå ìàññèâ:');
 17   for i := 1 to k do begin
 18     read(t);
 19     B[i] := 0;
 20     while t > 0 do begin
 21       B[i] := B[i] * 10 + (t mod 10);
 22       t := t div 10;
 23     end;
 24   end;
 25   
 26   writeln('Ìàññèâ B:');
 27   for i := 1 to k do
 28     write(B[i], ' ');
 29 end.
}}}
/* Program "lab4_prog2" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,int> B;
int k, i, t;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹4 ïðîãðàììà 2");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, âàðèàíò çàäàíèÿ 2");
  writeln(1, "Çàäàíèå ¹2");
  do
  {
    write(3, "Ââåäèòå k, äëèíó ìàññèâà B, íàòóðàëüíîå ÷èñëî îò 1 äî ", lmax, ": ");
    read(k);
  } while (!((k >= 1) && (k <= lmax)));
  writeln(1, "Ââåäèòå ìàññèâ:");
  for (i = 1; i <= k; i++)
  {
    read(t);
    B[i] = 0;
    while (t > 0)
    {
      B[i] = B[i] * 10 + (t % 10);
      t = t / 10;
    }
  }
  writeln(1, "Ìàññèâ B:");
  for (i = 1; i <= k; i++)
    write(2, B[i], " ");
  return 0;
}

test/labs/lab5-1.pas ==================================================================
{{{
  1 program lab5_prog1;
  2 var nr, mr : real; n, m : integer;
  3 
  4 function lnf(k : integer) : real; 
  5 begin
  6   for k := k downto 1 do
  7     result := result + ln(k);
  8 end;
  9 
 10 begin
 11   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 1');
 12   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹1 (âàð 2)');
 13   repeat
 14     write('Ââåäèòå öåëûå ÷èñëà n è m, ãäå m >= n >= 0: ');
 15     read(nr);
 16     read(mr);
 17   until (nr >= 0) and (mr >= nr)
 18       and (abs(nr) < maxint) and (abs(mr) < maxint)
 19       and (round(nr) = nr) and (round(mr) = mr);
 20   n := round(nr);
 21   m := round(mr);
 22   writeln('a = ', exp(lnf(m) - lnf(n) - lnf(m-n)));
 23 end.
}}}
/* Program "lab5_prog1" */
#include "p2c2stdlib.h"

float nr, mr;
int n, m;

float lnf(int k)
{
  for (k = k; k >= 1; k--)
    result = result + ln(k);
}
int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 1");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹1 (âàð 2)");
  do
  {
    write(1, "Ââåäèòå öåëûå ÷èñëà n è m, ãäå m >= n >= 0: ");
    read(nr);
    read(mr);
  } while (!((nr >= 0) && (mr >= nr) && (abs(nr) < maxint) && (abs(mr) < maxint) && (round(nr) == nr) && (round(mr) == mr)));
  n = round(nr);
  m = round(mr);
  writeln(2, "a = ", exp(lnf(m) - lnf(n) - lnf(m-n)));
  return 0;
}

test/labs/lab5-2.pas ==================================================================
{{{
  1 program lab5_prog2;
  2 const lmax = 20;
  3 var i, j, n, m : integer; nr, mr, min, max : real;
  4     a : array [1..lmax, 1..lmax] of real;
  5 begin
  6   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 2');
  7   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹2 (âàð 7)');
  8   
  9   repeat
 10     write('Ââåäèòå n: ');
 11     read(nr);
 12   until (nr > 0) and (nr <= lmax) and (nr = round(nr));
 13   n := round(nr);
 14   repeat
 15      write('Ââåäèòå m: ');
 16      read(mr);
 17   until (mr > 0) and (mr <= lmax) and (mr = round(mr));
 18   m := round(mr);
 19   
 20   writeln('Ââåäèòå ìàòðèöó:');
 21   for i := 1 to n do
 22       for j := 1 to m do
 23        read(a[i,j]);
 24 
 25   max := a[1,1];
 26   for i := 1 to n do begin
 27     min := maxint;
 28     for j := 1 to m do
 29       if abs(a[i,j]) < abs(min) then
 30         min := a[i,j];
 31     if min > max then
 32       max := min;
 33   end;
 34 
 35   writeln('D = ', max);
 36 end.
}}}
/* Program "lab5_prog2" */
#include "p2c2stdlib.h"

const int lmax = 20;

int i, j, n, m;
float nr, mr, min, max;
array<1,lmax,array<1,lmax,float>> a;

int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 2");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹2 (âàð 7)");
  do
  {
    write(1, "Ââåäèòå n: ");
    read(nr);
  } while (!((nr > 0) && (nr <= lmax) && (nr == round(nr))));
  n = round(nr);
  do
  {
    write(1, "Ââåäèòå m: ");
    read(mr);
  } while (!((mr > 0) && (mr <= lmax) && (mr == round(mr))));
  m = round(mr);
  writeln(1, "Ââåäèòå ìàòðèöó:");
  for (i = 1; i <= n; i++)
    for (j = 1; j <= m; j++)
      read(a[i][j]);
  max = a[1][1];
  for (i = 1; i <= n; i++)
  {
    min = maxint;
    for (j = 1; j <= m; j++)
      if (abs(a[i][j]) < abs(min))
        min = a[i][j];
    if (min > max)
      max = min;
  }
  writeln(2, "D = ", max);
  return 0;
}

test/labs/lab5-3.pas ==================================================================
{{{
  1 program lab5_prog3;
  2 const lmax = 20;
  3 type arr = array [1..lmax] of real;
  4 var i, n : integer; nr : real; a : arr;
  5 
  6 procedure uniq(var n : integer; var a : arr);
  7 var nn, j, i : integer; na : arr;
  8 begin
  9   nn := 0;
 10   for i := 1 to n do begin
 11     j := 1;
 12     while (j <= nn) and (a[i] <> na[j]) do
 13       inc(j);
 14     if j > nn then begin
 15       inc(nn);
 16       na[nn] := a[i]
 17     end
 18   end;
 19   n := nn;
 20   a := na;
 21 end;
 22 
 23 procedure countRepeats(n : integer; var a : arr);
 24 var reps, nn, i, j : integer; uniq : arr;
 25 begin
 26   for i := 1 to n do begin
 27     write('a[', i:2, '] = ', a[i]:2, ' ; ');
 28     reps := 0;
 29     for j := 1 to n do
 30       if (i <> j) and (a[i] = a[j]) then
 31         inc(reps);
 32     writeln('âñòðå÷àåòñÿ ðàç: ', reps);
 33   end
 34 end;
 35 
 36 begin
 37   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 3');
 38   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹3 (âàð 2)');
 39   
 40   repeat
 41     write('Ââåäèòå n: ');
 42     read(nr);
 43   until (nr > 0) and (nr <= lmax) and (nr = round(nr));
 44   n := round(nr);
 45   
 46   writeln('Ââåäèòå ìàññèâ:');
 47   for i := 1 to n do begin
 48     repeat
 49       write('Ââåäèòå A[', i, ']: ');
 50       read(nr);
 51     until (abs(nr) < maxint) and (nr = round(nr));
 52     a[i] := round(nr);
 53   end;
 54   
 55   countRepeats(n, a);
 56   
 57   uniq(n, a);
 58   
 59   writeln('Ìàññèâ B:');
 60   for i := 1 to n do
 61     write(a[i], ' ');
 62 end.
}}}
/* Program "lab5_prog3" */
#include "p2c2stdlib.h"

const int lmax = 20;

int i, n;
float nr;
array<1,lmax,float> a;

void uniq(int &n, array<1,lmax,float> &a)
{
  int nn, j, i;
  array<1,lmax,float> na;

  nn = 0;
  for (i = 1; i <= n; i++)
  {
    j = 1;
    while ((j <= nn) && (a[i] != na[j]))
      inc(j);
    if (j > nn)
    {
      inc(nn);
      na[nn] = a[i];
    }
  }
  n = nn;
  a = na;
}
void countRepeats(int n, array<1,lmax,float> &a)
{
  int reps, nn, i, j;
  array<1,lmax,float> uniq;

  for (i = 1; i <= n; i++)
  {
    write(5, "a[", width_format(i, 2), "] = ", width_format(a[i], 2), " ; ");
    reps = 0;
    for (j = 1; j <= n; j++)
      if ((i != j) && (a[i] == a[j]))
        inc(reps);
    writeln(2, "âñòðå÷àåòñÿ ðàç: ", reps);
  }
}
int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹5 ïðîãðàììà 3");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèå ¹3 (âàð 2)");
  do
  {
    write(1, "Ââåäèòå n: ");
    read(nr);
  } while (!((nr > 0) && (nr <= lmax) && (nr == round(nr))));
  n = round(nr);
  writeln(1, "Ââåäèòå ìàññèâ:");
  for (i = 1; i <= n; i++)
  {
    do
    {
      write(3, "Ââåäèòå A[", i, "]: ");
      read(nr);
    } while (!((abs(nr) < maxint) && (nr == round(nr))));
    a[i] = round(nr);
  }
  countRepeats(n, a);
  uniq(n, a);
  writeln(1, "Ìàññèâ B:");
  for (i = 1; i <= n; i++)
    write(2, a[i], " ");
  return 0;
}

test/labs/lab6.pas ==================================================================
{{{
  1 program lab6;
  2 const lmax = 20;
  3 type strings = array [1..lmax] of string;
  4 var s, subs : strings; i, k, n, smallest, err : integer; reads, dots : string;
  5 
  6 procedure filterSubstrings(k : integer; s : strings;
  7     var n : integer; var subs : strings);
  8 var it, j, j1 : integer; cur : string;
  9 begin
 10   n := 0;
 11   for it := 1 to k do begin
 12     cur := s[it];
 13     j := 1;
 14     j1 := 1;
 15     while j <= length(cur) do
 16       if ((cur[j] = '[') or (cur[j] = ']')) then begin
 17         if j <> 1 then begin
 18           n := n + 1;
 19           subs[n] := copy(cur, j1, j - j1);
 20         end; 
 21         while (j <= length(cur)) and ((cur[j] = '[') or (cur[j] = ']')) do
 22           j := j + 1;
 23         j1 := j;
 24       end else
 25         j := j + 1;
 26     if j <> j1 then begin
 27       n := n + 1;
 28       subs[n] := copy(cur, j1, j - j1);
 29     end;      
 30   end;  
 31 end;
 32 
 33 procedure findSmallest(n : integer; var subs : strings; var idx : integer);
 34 var ml, i : integer;
 35 begin
 36   ml := length(subs[1]); idx := 1;
 37   for i := 1 to n do
 38     if length(subs[i]) < ml then begin
 39       ml := length(subs[i]);
 40       idx := i
 41     end;
 42 end;
 43 
 44 procedure insertDots(var s : string);
 45 var i : integer;
 46 begin
 47   i := 1;
 48   while (i <= length(s)) and (not (s[i] in ['0'..'9'])) do
 49     inc(i);
 50   if i <= length(s) then
 51     insert('...', s, i+1);
 52 end;
 53 
 54 begin
 55   writeln('Ëàáîðàòîðíàÿ ðàáîòà ¹6');
 56   writeln('Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ 10, 2, 10');
 57   
 58   writeln('Çàäàíèå 1');
 59   repeat
 60     write('Ââåäèòå íàòóðàëüíîå ÷èñëî k: ');
 61     readln(reads);
 62     val(reads, k, err);
 63   until (err = 0) and (k > 0) and (k <= lmax);
 64   
 65   writeln('Ââåäèòå ñòðîêè:');
 66   for i := 1 to k do
 67     readln(s[i]);
 68     
 69   filterSubstrings(k, s, n, subs);
 70     
 71   if n = 0 then 
 72     writeln('Íåò ïîäñòðîê') 
 73   else begin
 74     { if n = k then
 75       writeln('Óäàëåíèé íå áûëî.')
 76     else begin }
 77       writeln('Ïîäñòðîêè:');
 78       for i := 1 to n do
 79         writeln(subs[i]);
 80     { end; }
 81       
 82     writeln('Çàäàíèå 2');
 83     findSmallest(n, subs, smallest);
 84     writeln('Íàèìåíüøàÿ:');
 85     writeln(subs[smallest]);
 86 
 87     writeln('Çàäàíèå 3');
 88     dots := subs[smallest];
 89     insertDots(dots);
 90     if dots = subs[smallest] then
 91       writeln('Öèôð â íàéäåííîé ïîäñòðîêå íåò.')
 92     else begin
 93       writeln('Ïðåîáðàçîâàííàÿ:');
 94       writeln(dots);
 95     end
 96   end;
 97 end.
}}}
/* Program "lab6" */
#include "p2c2stdlib.h"

const int lmax = 20;

array<1,lmax,string> s, subs;
int i, k, n, smallest, err;
string reads, dots;

void filterSubstrings(int k, array<1,lmax,string> s, int &n, array<1,lmax,string> &subs)
{
  int it, j, j1;
  string cur;

  n = 0;
  for (it = 1; it <= k; it++)
  {
    cur = s[it];
    j = 1;
    j1 = 1;
    while (j <= length(cur))
      if (((cur[j] == "[") || (cur[j] == "]")))
      {
        if (j != 1)
        {
          n = n + 1;
          subs[n] = copy(cur, j1, j - j1);
        }
        while ((j <= length(cur)) && ((cur[j] == "[") || (cur[j] == "]")))
          j = j + 1;
        j1 = j;
      }
      else
        j = j + 1;
    if (j != j1)
    {
      n = n + 1;
      subs[n] = copy(cur, j1, j - j1);
    }
  }
}
void findSmallest(int n, array<1,lmax,string> &subs, int &idx)
{
  int ml, i;

  ml = length(subs[1]);
  idx = 1;
  for (i = 1; i <= n; i++)
    if (length(subs[i]) < ml)
    {
      ml = length(subs[i]);
      idx = i;
    }
}
void insertDots(string &s)
{
  int i;

  i = 1;
  while ((i <= length(s)) && (!((s[i] & set("0","9")))))
    inc(i);
  if (i <= length(s))
    insert("...", s, i + 1);
}
int main()
{
  writeln(1, "Ëàáîðàòîðíàÿ ðàáîòà ¹6");
  writeln(1, "Àêáàøåâ Ðóñëàí, ãðóïïà ÁÈÂ155, âàðèàíò 141, çàäàíèÿ 10, 2, 10");
  writeln(1, "Çàäàíèå 1");
  do
  {
    write(1, "Ââåäèòå íàòóðàëüíîå ÷èñëî k: ");
    readln(reads);
    val(reads, k, err);
  } while (!((err == 0) && (k > 0) && (k <= lmax)));
  writeln(1, "Ââåäèòå ñòðîêè:");
  for (i = 1; i <= k; i++)
    readln(s[i]);
  filterSubstrings(k, s, n, subs);
  if (n == 0)
    writeln(1, "Íåò ïîäñòðîê");
  else
  {
    writeln(1, "Ïîäñòðîêè:");
    for (i = 1; i <= n; i++)
      writeln(1, subs[i]);
    writeln(1, "Çàäàíèå 2");
    findSmallest(n, subs, smallest);
    writeln(1, "Íàèìåíüøàÿ:");
    writeln(1, subs[smallest]);
    writeln(1, "Çàäàíèå 3");
    dots = subs[smallest];
    insertDots(dots);
    if (dots == subs[smallest])
      writeln(1, "Öèôð â íàéäåííîé ïîäñòðîêå íåò.");
    else
    {
      writeln(1, "Ïðåîáðàçîâàííàÿ:");
      writeln(1, dots);
    }
  }
  return 0;
}

test/labs/lab7-1.pas ==================================================================
{{{
  1 ï»¿program p1;
  2 
  3 var
  4   r, rmax: Real;
  5   f: File of Real;
  6   filename, buf: String;
  7   err, nn, i: Integer;
  8 
  9 begin
 10   writeln('ÐÐ°Ð±Ð¾ÑÐ°ÑÐ¾ÑÐ½Ð°Ñ ÑÐ°Ð±Ð¾ÑÐ° â7');
 11   writeln('ÐÐºÐ±Ð°ÑÐµÐ² Ð ÑÑÐ»Ð°Ð½, Ð³ÑÑÐ¿Ð¿Ð° ÐÐÐ155, Ð²Ð°ÑÐ¸Ð°Ð½Ñ 141, Ð·Ð°Ð´Ð°Ð½Ð¸Ðµ 1 (10)');
 12 
 13   repeat
 14     write('ÐÐ¼Ñ ÑÐ°Ð¹Ð»Ð° Ð·Ð°Ð¿Ð¸ÑÐ¸: ');
 15     readln(filename);
 16   until CanCreateFile(filename);
 17   
 18   assign(f, filename);
 19   
 20   rewrite(f);
 21   
 22   repeat
 23     write('ÐÐ²ÐµÐ´Ð¸ÑÐµ ÐºÐ¾Ð»Ð¸ÑÐµÑÑÐ²Ð¾ ÑÐ¸ÑÐµÐ»: ');
 24     readln(buf);
 25     val(buf, nn, err)
 26   until (err = 0) and (nn > 0);
 27   for i := 1 to nn do begin
 28     repeat
 29       write('ÐÐ²ÐµÐ´Ð¸ÑÐµ ÑÐ»ÐµÐ¼ÐµÐ½Ñ â', i, ': ');
 30       readln(buf);
 31       val(buf, r, err)
 32     until (err = 0);
 33     write(f, r);
 34   end;
 35   
 36   close(f);
 37   
 38   reset(f);
 39   
 40   rmax := 0;
 41   i := 1;
 42   while not eof(f) do begin
 43     read(f, r);
 44     if ((r > rmax) or (rmax = 0)) and (i mod 2 = 1)
 45       then rmax := r;
 46     inc(i);
 47   end;
 48   writeln('ÐÐ°ÐºÑÐ¸Ð¼Ð°Ð»ÑÐ½Ð¾Ðµ ÑÐ¸ÑÐ»Ð¾: ', rmax);
 49   
 50   close(f);
 51 end.
}}}
unknown character 'ï' in string on line 1
unknown character '»' in string on line 1
unknown character '¿' in string on line 1
Variable declaration of "f": Typed File-type variables are not supported in C
test/labs/lab7-2.pas ==================================================================
{{{
  1 program p2;
  2 
  3 var
  4   inf, outf: Text;
  5   inFilename, outFilename, row: String;
  6   counter, i: Integer;
  7 
  8 begin
  9   writeln('ÐÐ°Ð±Ð¾ÑÐ°ÑÐ¾ÑÐ½Ð°Ñ ÑÐ°Ð±Ð¾ÑÐ° â7');
 10   writeln('ÐÐºÐ±Ð°ÑÐµÐ² Ð ÑÑÐ»Ð°Ð½, Ð³ÑÑÐ¿Ð¿Ð° ÐÐÐ155, Ð²Ð°ÑÐ¸Ð°Ð½Ñ 141, Ð·Ð°Ð´Ð°Ð½Ð¸Ðµ 2 (7)');
 11 
 12   repeat
 13     write('ÐÐ²ÐµÐ´Ð¸ÑÐµ Ð¸Ð¼Ñ ÑÐ¸ÑÐ°ÐµÐ¼Ð¾Ð³Ð¾ ÑÐ°Ð¹Ð»Ð°: ');
 14     readln(inFilename)
 15   until FileExists(inFilename);
 16   assign(inf, inFilename);
 17   reset(inf);
 18   
 19   repeat
 20     write('ÐÐ¼Ñ ÑÐ°Ð¹Ð»Ð° Ð´Ð»Ñ Ð·Ð°Ð¿Ð¸ÑÐ¸: ');
 21     readln(outFilename);
 22     if FileExists(outFilename)
 23       then writeln('Ð¤Ð°Ð¹Ð» Ñ ÑÐ°ÐºÐ¸Ð¼ Ð¸Ð¼ÐµÐ½ÐµÐ¼ ÑÐ¶Ðµ ÑÑÑÐµÑÑÐ²ÑÐµÑ')
 24   until CanCreateFile(outFilename) and not FileExists(outFilename);
 25   assign(outf, outFilename);
 26   rewrite(outf);
 27   
 28   counter := 0;
 29   while not eof(inf) do begin
 30     readln(inf, row);
 31     for i := 1 to length(row) do begin
 32       while (row[i] in ['0'..'9']) and (i <= length(row)) do begin
 33         inc(counter);
 34         inc(i);
 35       end;
 36       if counter >= 2 then begin
 37         counter := 0;
 38         insert('A', row, i);
 39       end else
 40         counter := 0;
 41     end;
 42     writeln(outf, row);
 43   end;
 44   
 45   close(inf);
 46   close(outf);
 47 end.
}}}
Syntax error: unknown type "Text" in variable declaration of "inf"
test/labs/lab7-3.pas ==================================================================
{{{
  1 program p3;
  2 
  3 const lmax = 40;
  4 
  5 type
  6   tv = record
  7     manufacturer: record
  8       city, factory: String;
  9     end;
 10     name: String;
 11     params: record
 12       year, price: Integer;
 13       size: Real;
 14     end;
 15   end;
 16 
 17 var
 18   records: array [1..lmax] of tv;
 19   nr, i, searchedIdx, maxYear, minPrice: Integer;
 20   f: File of tv;
 21   name: String;
 22 
 23 begin
 24   writeln('ÐÐ°Ð±Ð¾ÑÐ°ÑÐ¾ÑÐ½Ð°Ñ ÑÐ°Ð±Ð¾ÑÐ° â7');
 25   writeln('ÐÐºÐ±Ð°ÑÐµÐ² Ð ÑÑÐ»Ð°Ð½, Ð³ÑÑÐ¿Ð¿Ð° ÐÐÐ155, Ð²Ð°ÑÐ¸Ð°Ð½Ñ 141, Ð·Ð°Ð´Ð°Ð½Ð¸Ðµ 3 (12)');
 26 
 27   repeat
 28     write('ÐÐ¼Ñ ÑÐ°Ð¹Ð»Ð° Ð´Ð»Ñ Ð·Ð°Ð¿Ð¸ÑÐ¸: ');
 29     readln(name);
 30   until CanCreateFile(name);
 31   
 32   assign(f, name);
 33   rewrite(f);
 34   
 35   repeat
 36     write('ÐÐ¾Ð»Ð¸ÑÐµÑÑÐ²Ð¾ Ð·Ð°Ð¿Ð¸ÑÐµÐ¹: ');
 37     readln(nr);
 38   until nr in [1..lmax];
 39   
 40   writeln('ÐÐ²ÐµÐ´Ð¸ÑÐµ Ð´Ð°Ð½Ð½ÑÐµ:');
 41   for i := 1 to nr do begin
 42     with records[i] do begin
 43       with manufacturer do begin
 44         write('ÐÐ¾ÑÐ¾Ð´ Ð¸Ð·Ð³Ð¾ÑÐ¾Ð²Ð¸ÑÐµÐ»Ñ: ');
 45         readln(city);
 46         write('ÐÐ°Ð²Ð¾Ð´: ');
 47         readln(factory);
 48       end;
 49       write('ÐÐ°Ð·Ð²Ð°Ð½Ð¸Ðµ: ');
 50       readln(name);
 51       with params do begin
 52         repeat
 53           write('ÐÐ¾Ð´ Ð²ÑÐ¿ÑÑÐºÐ°: ');
 54           readln(year);
 55         until (year > 1900) and (year <= 2015);
 56 
 57         repeat
 58           write('Ð¦ÐµÐ½Ð°: ');
 59           readln(price);
 60         until price > 0;
 61 
 62         repeat
 63           write('Ð Ð°Ð·Ð¼ÐµÑ ÑÐºÑÐ°Ð½Ð°: ');
 64           readln(size);
 65         until size > 0;
 66         writeln;
 67       end;
 68     end;
 69     write(f, records[i]);
 70   end;
 71   close(f);
 72   
 73   searchedIdx := 0;
 74   maxYear := records[1].params.year;
 75   minPrice := 0;
 76   for i := 1 to nr do
 77     with records[i], params do
 78       if (year >= maxYear) or (maxYear = 0) then
 79         maxYear := year;
 80   for i := 1 to nr do
 81     with records[i], params do
 82       if ((price < minPrice) or (minPrice = 0)) and (year = maxYear) then begin
 83         minPrice := price;
 84         searchedIdx := i
 85       end;
 86 
 87   writeln('ÐÑÐºÐ¾Ð¼ÑÐ¹ ÑÐµÐ»ÐµÐ²Ð¸Ð·Ð¾Ñ: ', records[searchedIdx].name);
 88 end.
}}}
Variable declaration of "f": Typed File-type variables are not supported in C
test/labs/lab8.pas ==================================================================
{{{
  1 program woop;
  2 
  3 type nodeptr = ^node;
  4   node = record
  5     next: nodeptr;
  6     data: integer;
  7   end;
  8 
  9 var root: ^node;
 10 
 11 procedure print(var root: ^node);
 12 var p: ^node;
 13 begin
 14   p := root;
 15   while true do begin
 16     write(p^.data, ' -> ');
 17     if p^.next = nil then begin
 18       writeln('end');
 19       break;
 20     end;
 21     p := p^.next
 22   end;
 23 end;
 24   
 25 procedure make_queue(var root: ^node);
 26 var
 27   t: integer;
 28   p, temp: ^node;
 29 begin
 30   writeln('âåäèòå öåëûå ÷èñëà äëß çàïèñè:');
 31   writeln('(-1 îáîçíà÷àåò êîíåö ïîñëåäîâàòåëüíîñòè)');
 32   read(t);
 33   if t = -1 then
 34     root := nil
 35   else begin
 36     new(root);
 37     temp := root;
 38     repeat
 39       p := temp;
 40       new(temp);
 41       p^.next := temp;
 42       p^.data := t;
 43       read(t);
 44     until t = -1;
 45     p^.next := nil;
 46     dispose(temp);
 47   end;
 48 end;
 49 
 50 procedure process(var root: ^node);
 51 var p, t: ^node; i, a1: integer;
 52 begin
 53   p := root;
 54   i := 1;
 55   write('âåäèòå ÷èñëî A1: ');
 56   read(a1);
 57   while true do begin
 58     if i mod 2 = 1 then begin
 59       t := p^.next;
 60       new(p^.next);
 61       p^.next^.next := t;
 62       p^.next^.data := a1;
 63     end;
 64     if p^.next = nil then
 65       break;
 66     p := p^.next;
 67     inc(i);
 68   end;
 69 end;
 70 
 71 procedure removals(var root: ^node);
 72 var p, t: ^node; i, f, l: integer;
 73 begin
 74   p := root;
 75   f := 0;
 76   i := 0;
 77   while true do begin
 78     inc(i);
 79     if p^.data mod 2 = 0 then begin
 80       if f = 0 then
 81         f := i;
 82       l := i;
 83     end;
 84     if p^.next = nil then
 85       break;
 86     p := p^.next;
 87   end;
 88   if f = 0 then
 89     writeln(' î÷åðåäè íå ñóùåñòâóþò ÷Þòíûå ýëåìåíòû')
 90   else if f = l then
 91     writeln(' î÷åðåäè ñóùåñòâóåò òîëüêî îäèí ÷Þòíûé ýëåìåíò')
 92   else begin
 93     p := root;
 94     i := 0;
 95     while true do begin
 96       inc(i);
 97       if i = f then
 98         break;
 99       p := p^.next;
100     end;
101     while i <> l-1 do begin
102       inc(i);
103       t := p^.next^.next;
104       dispose(p^.next);
105       p^.next := t;
106     end;
107   end;
108 end;
109 
110 begin
111   make_queue(root);
112   if root = nil then
113     writeln('óñòàß î÷åðåäü')
114   else begin
115     print(root);
116     process(root);
117     print(root);
118     removals(root);
119     print(root);
120   end;
121 end.
}}}
/* Program "woop" */
#include "p2c2stdlib.h"

struct rec1 { rec1 *next; int data; } *root;

void print(rec1 &root)
{
  struct rec1 { rec1 *next; int data; } *p;

  p = root;
  while (true)
  {
    write(2, (*p).data, " -> ");
    if ((*p).next == NULL)
    {
      writeln(1, "end");
      break;
    }
    p = (*p).next;
  }
}
void make_queue(rec1 &root)
{
  int t;
  struct rec1 { rec1 *next; int data; } *p, *temp;

  writeln(1, "âåäèòå öåëûå ÷èñëà äëß çàïèñè:");
  writeln(1, "(-1 îáîçíà÷àåò êîíåö ïîñëåäîâàòåëüíîñòè)");
  read(t);
  if (t == -1)
    root = NULL;
  else
  {
    new(root);
    temp = root;
    do
    {
      p = temp;
      new(temp);
      (*p).next = temp;
      (*p).data = t;
      read(t);
    } while (!(t == -1));
    (*p).next = NULL;
    dispose(temp);
  }
}
void process(rec1 &root)
{
  struct rec1 { rec1 *next; int data; } *p, *t;
  int i, a1;

  p = root;
  i = 1;
  write(1, "âåäèòå ÷èñëî A1: ");
  read(a1);
  while (true)
  {
    if (i % 2 == 1)
    {
      t = (*p).next;
      new((*p).next);
      (*(*p).next).next = t;
      (*(*p).next).data = a1;
    }
    if ((*p).next == NULL)
      break;
    p = (*p).next;
    inc(i);
  }
}
void removals(rec1 &root)
{
  struct rec1 { rec1 *next; int data; } *p, *t;
  int i, f, l;

  p = root;
  f = 0;
  i = 0;
  while (true)
  {
    inc(i);
    if ((*p).data % 2 == 0)
    {
      if (f == 0)
        f = i;
      l = i;
    }
    if ((*p).next == NULL)
      break;
    p = (*p).next;
  }
  if (f == 0)
    writeln(1, " î÷åðåäè íå ñóùåñòâóþò ÷Þòíûå ýëåìåíòû");
  else
    if (f == l)
      writeln(1, " î÷åðåäè ñóùåñòâóåò òîëüêî îäèí ÷Þòíûé ýëåìåíò");
    else
    {
      p = root;
      i = 0;
      while (true)
      {
        inc(i);
        if (i == f)
          break;
        p = (*p).next;
      }
      while (i != l-1)
      {
        inc(i);
        t = (*(*p).next).next;
        dispose((*p).next);
        (*p).next = t;
      }
    }
}
int main()
{
  make_queue(root);
  if (root == NULL)
    writeln(1, "óñòàß î÷åðåäü");
  else
  {
    print(root);
    process(root);
    print(root);
    removals(root);
    print(root);
  }
  return 0;
}
```

