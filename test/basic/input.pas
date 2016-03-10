program ye(wyt, what);
label 420, 2517;
const lmax = 20;
type
  natural = 0..maxint;
  count = integer;
  range = integer;
  angle = 0..360;
  colour = (red, yellow, green, blue);
  sex = (male, female);
  year = 1900..1999;
  asdf = -10..+10;
  wdydt = '0'..'9';
  yyk = red..green;
  shape = (triangle, rectangle, circle);
  punchedcard = array [1..80] of char;
  win = array [Boolean] of colour;
  size = 1..20;
  send = array [Boolean] of array [1..10] of array [size] of real;
  help = packed array [Boolean] of array [1..10, size] of real;
  charsequence = file of char;
  polar = record
            r : real;
            theta: angle;
            year: 0..2000;
            name, firstname: string;
            case shape of
              triangle :
                (side : real ; inclination, angle1, angle2 : angle);
              rectangle :
                (side1, side2 : real; sadfj : angle);
              circle :
                (diameter : real);
          end;
  indextype = 1..lmax;
  masti = set of (club, diamond, heart, spade);
  vector = array [indextype] of real;
  person = ^ persondetails;
  persondetails = record
                    name, firstname: charsequence;
                    age : natural;
                    father, child, sibling : person;
                    case married : Boolean of
                      true : (Gal : string);
                      false : ( );
                  end;
FileOfInteger = file of integer;

begin
	writeln('asdf');
	readln;
end.
