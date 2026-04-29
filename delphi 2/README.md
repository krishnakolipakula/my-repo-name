# Delphi Project

## Team Members
- Krishna Chaitanya Kolipakula (UFID: 94059870)
- Karthikeya Ruthvik Pakki (UFID: 52291889)

## Overview
This project extends Pascal with object-oriented programming features including classes, objects, constructors, destructors, and encapsulation. The implementation uses ANTLR4 for parsing and includes a Java-based interpreter.

## What Works

### Core Features
- Classes and class definitions
- Object creation using the new keyword
- Constructors that are automatically called when objects are created
- Destructors that are automatically called at program end
- Encapsulation with private fields inside classes
- Methods (procedures) that can be called on objects
- Input functionality using readln() for reading integers
- Output functionality using writeln() for printing integers

### Bonus Features
- Inheritance where child classes can inherit from parent classes
- Interfaces that define method signatures

## Project Structure
- src/main/antlr4/delphi.g4 - The ANTLR4 grammar file
- src/main/java/Interpreter.java - The interpreter implementation
- src/main/java/Main.java - The main entry point
- tests/test1.pas - Test for basic class features and I/O
- tests/test2.pas - Test for encapsulation and destructors
- tests/test3.pas - Test for inheritance
- tests/test4.pas - Test for interfaces
- pom.xml - Maven build configuration

## Prerequisites
- Java 11 or higher
- Maven 3.6 or higher

## How to Build
Run the following command in the project directory:
```
mvn clean compile
```

This will generate the parser and lexer from the grammar file and compile all Java sources.

## How to Run

### Using Maven
```
mvn exec:java -Dexec.args="tests/test1.pas"
```

### Using Java directly
```
java -cp "target/classes:target/generated-sources/antlr4:~/.m2/repository/org/antlr/antlr4-runtime/4.11.1/antlr4-runtime-4.11.1.jar" Main tests/test1.pas
```

### Using the test script
```
bash run_tests.sh
```

## Test Cases

### test1.pas
Tests basic class definition, constructor with input, and method with output.
- Input: An integer (e.g., 42)
- Output: The same integer

### test2.pas
Tests encapsulation with private fields, multiple methods, and destructor.
- Input: None
- Output: 1 (from increment and print), then 0 (from destructor)

### test3.pas
Tests inheritance where a child class inherits fields and methods from a parent class.
- Input: An integer (e.g., 5)
- Output: The same integer

### test4.pas
Tests interface declaration and implementation.
- Input: An integer (e.g., 100)
- Output: The same integer

## Running Individual Tests

For tests that require input, provide it via echo:
```
echo "42" | java -cp "target/classes:target/generated-sources/antlr4:~/.m2/repository/org/antlr/antlr4-runtime/4.11.1/antlr4-runtime-4.11.1.jar" Main tests/test1.pas
```

For tests without input:
```
java -cp "target/classes:target/generated-sources/antlr4:~/.m2/repository/org/antlr/antlr4-runtime/4.11.1/antlr4-runtime-4.11.1.jar" Main tests/test2.pas
```

## Notes
- The destructor is called automatically at the end of program execution for all created objects
- Inheritance copies parent fields and methods to child classes at class definition time
- Interfaces are parsed and recognized but not enforced at runtime
