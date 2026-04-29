A = class
begin
  private var x: integer;
  
  constructor() 
  begin 
    x := 10; 
  end
  
  destructor() 
  begin 
    writeln(0); 
  end
end

var a: A;
a := A.Create();
writeln(a.x);
