procedure showX()
begin
  writeln(x);
end

var x: integer;
var i: integer;

x := 10;

for i := 1 to 1 do
begin
  var x: integer;
  x := 99;
  showX();
end
