{ Loop control flow test }
var i: integer;
begin
  writeln(7);
  i := 1;
  while i = 1 do
  begin
    writeln(i);
    i := 0;
  end;
  
  for i := 1 to 3 do
    writeln(i);
    
  for i := 3 downto 1 do
    writeln(i);
end.
