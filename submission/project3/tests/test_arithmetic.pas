{ Complex arithmetic expressions }
var a: integer;
var b: integer;
var c: integer;
var d: integer;
begin
  a := 10;
  b := 5;
  c := 0;
  d := 0;
  
  c := a + b;
  writeln(c);
  
  d := a * b - b;
  writeln(d);
  
  d := a * b / 5 * 3;
  writeln(d);
end.
