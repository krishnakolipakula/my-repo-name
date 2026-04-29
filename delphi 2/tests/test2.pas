// Sample test case for encapsulation and destructor

class Counter {
    var value: integer;
    constructor() {
        value = 0;
    }
    procedure increment() {
        value = value + 1;
    }
    procedure print() {
        writeln(value);
    }
    destructor() {
        writeln(0);
    }
}

var c: Counter;
c = new Counter();
c.increment();
c.print();
// Destructor will be called automatically at program end
