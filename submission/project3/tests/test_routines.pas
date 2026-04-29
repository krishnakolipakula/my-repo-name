{ Function test }
function add(x: integer; y: integer): integer
begin
  add := x + y;
end;

function multiply(x: integer; y: integer): integer
begin
  multiply := x * y;
end;

var result: integer;
begin
  result := add(2, 3);
  writeln(result);
  
  result := multiply(5, 3);
  writeln(result);
end.
