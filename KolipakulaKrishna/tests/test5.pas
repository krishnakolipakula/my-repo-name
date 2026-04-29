// Test for multiple objects and arithmetic operations

Calculator = class begin
    private var result: integer;
    constructor() begin
        result := 0;
    end
    procedure add() begin
        result := result + 10;
    end
    procedure multiply() begin
        result := result * 2;
    end
    procedure show() begin
        writeln(result);
    end
end

var calc1: Calculator;
var calc2: Calculator;

calc1 := Calculator.Create();
calc2 := Calculator.Create();

calc1.add();
calc1.add();
calc1.show();

calc2.add();
calc2.multiply();
calc2.show();
