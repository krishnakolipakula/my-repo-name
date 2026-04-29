// Sample test case for encapsulation and destructor

Counter = class begin
    private var value: integer;
    constructor() begin
        value := 0;
    end
    procedure increment() begin
        value := value + 1;
    end
    procedure print() begin
        writeln(value);
    end
    destructor() begin
        writeln(0);
    end
end

var c: Counter;
c := Counter.Create();
c.increment();
c.print();
// Destructor will be called automatically at program end
