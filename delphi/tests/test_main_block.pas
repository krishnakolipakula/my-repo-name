Test = class
begin
  public var x: integer;
  constructor()
  begin
    x := 99;
  end
end

var t: Test;

begin
  t := Test.Create();
  writeln(t.x);
end.
