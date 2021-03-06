program TRI-HEAP;

   const N = 10;   
   var TABLE: array[1..N] of INTEGER;
       TEMP: INTEGER;

   procedure AJUSTE(var I,N: INTEGER);
      var TEMP,J: INTEGER;
          TERMINE: BOOLEAN;
   begin
      TEMP :=    TABLE[I];
      J    :=    2*I;
      TERMINE := FALSE;
 
      while (J<=N) and not TERMINE do
      begin
         if (J<N) and (TABLE[J]<TABLE[J+1]) then J := J+1;
         if TEMP>TABLE[J] then
	 TERMINE := TRUE
         else
	 begin
            TABLE[J/2] := TABLE[J];
            J := 2*J;
	 end;
      end;

      TABLE[J/2] := TEMP;

   end;

   procedure CONSTRUIRE-HEAP;
   begin
      for I := N/2 downto 1 do AJUSTE(I,N);
   end;

begin

   for I := 1 to N do READ(TABLE[I]);

   CONSTRUIRE-HEAP;

   for I := N-1 downto 1 do
   begin
      TEMP := TABLE[I+1];
      TABLE[I+1] := TABLE[1];
      TABLE[1] := TEMP;
      AJUSTE(1,I);
   end;

   for I := 1 to N do WRITE(TABLE[I]);

end.
