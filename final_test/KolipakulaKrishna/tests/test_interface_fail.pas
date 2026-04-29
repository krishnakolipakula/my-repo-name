Printable = interface
begin
  procedure display();
end

BadClass = class(Printable)
begin
  public var x: integer;
  
  constructor()
  begin
    x := 1;
  end
end

var b: BadClass;
b := BadClass.Create();
