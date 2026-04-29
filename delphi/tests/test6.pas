// Test for field access and multiple methods

Point = class begin
    private var x: integer;
    private var y: integer;
    constructor() begin
        readln(x);
        readln(y);
    end
    procedure display() begin
        writeln(x);
        writeln(y);
    end
end

var p: Point;
p := Point.Create();
p.display();
