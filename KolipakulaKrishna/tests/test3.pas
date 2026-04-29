// Sample test case for inheritance (bonus)

Animal = class begin
    public var name: integer;
    constructor() begin
        readln(name);
    end
    procedure speak() begin
        writeln(name);
    end
end

Dog = class(Animal) begin
    procedure speak() begin
        writeln(name);
    end
end

var d: Dog;
d := Dog.Create();
d.speak();
