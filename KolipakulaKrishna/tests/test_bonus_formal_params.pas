procedure printSum(a: integer, b: integer)
begin
  writeln(a + b);
end

function mulAdd(a: integer, b: integer, c: integer): integer
begin
  mulAdd := a * b + c;
end

var a: integer;
var b: integer;

a := 7;
b := 4;

printSum(a, b);
writeln(mulAdd(2, 3, 5));
