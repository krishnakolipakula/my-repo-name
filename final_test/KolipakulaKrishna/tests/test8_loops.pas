var i: integer;

while 1 do
begin
  writeln(7);
  break;
end

for i := 1 to 3 do
begin
  writeln(i);
  continue;
  writeln(999);
end

for i := 3 downto 1 do
begin
  writeln(i);
end
