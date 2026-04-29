// Sample test case for inheritance (bonus)

class Animal {
    var name: integer;
    constructor() {
        readln(name);
    }
    procedure speak() {
        writeln(name);
    }
}

class Dog : Animal {
    procedure speak() {
        writeln(name);
    }
}

var d: Dog;
d = new Dog();
d.speak();
