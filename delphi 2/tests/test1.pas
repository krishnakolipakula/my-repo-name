// Sample test case for class, constructor, input/output

class MyClass {
    var x: integer;
    constructor() {
        readln(x);
    }
    procedure printX() {
        writeln(x);
    }
}

var obj: MyClass;
obj = new MyClass();
obj.printX();
