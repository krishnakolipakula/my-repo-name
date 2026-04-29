Calculator = class
begin
  public var result: integer;
  
  constructor(initial: integer)
  begin
    result := initial;
  end
  
  procedure add(value: integer)
  begin
    result := result + value;
  end
  
  destructor()
  begin
    writeln(0);
  end
end

var calc: Calculator;

calc := Calculator.Create(10);
writeln(calc.result);
calc.add(5);
writeln(calc.result);
