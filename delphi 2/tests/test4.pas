// Sample test case for interface (bonus)

interface Printable {
    procedure print();
}

class Number : Printable {
    var n: integer;
    constructor() {
        readln(n);
    }
    procedure print() {
        writeln(n);
    }
}

var num: Number;
num = new Number();
num.print();
