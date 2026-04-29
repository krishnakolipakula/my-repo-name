// Sample test case for class, constructor, input/output

MyClass = class begin
    var x: integer;
    constructor() begin
        readln(x);
    end
    procedure printX() begin
        writeln(x);
    end
end

var obj: MyClass;
obj := MyClass.Create();
obj.printX();
