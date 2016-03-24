program records_test;

type date =
record
	year : 0..2000;
	month : 1..12;
	day : 1..31
end;

person =
record
	name, firstname : string;
	age : 0..99;
	case married : Boolean of
		true : (Spousesname : string);
		false : ( )
end;

what =
record
	x, y: real;
	area: real;
	case shape of
		triangle: (side: real ; inclination, angle1, angle2: angle);
		rectangle: (side1, side2: real ; skew: angle);
		circle: (diameter: real);
end;

begin
end.

