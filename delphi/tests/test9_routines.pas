procedure addToTotal(value: integer)
begin
  total := total + value;
end

function add(a: integer, b: integer): integer
begin
  add := a + b;
end

var total: integer;

total := 0;
addToTotal(10);
addToTotal(5);
writeln(total);
writeln(add(2, 3));
