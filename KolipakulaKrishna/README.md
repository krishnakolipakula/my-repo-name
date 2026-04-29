# Delphi Project

## Team Members
- Krishna Chaitanya Kolipakula (UFID: 94059870)
- Karthikeya Ruthvik Pakki (UFID: 52291889)

## Overview
This project extends Pascal with object-oriented programming features including classes, objects, constructors, destructors, and encapsulation. It also implements control-flow and routine features required in the continuation project: loops, break/continue, user-defined procedures/functions, and static scoping behavior for routine execution. The implementation uses ANTLR4 for parsing and includes a Java-based interpreter.

## What Works

### Core Features
- Classes and class definitions
- Object creation using Delphi-style `ClassName.Create(...)` syntax
- Constructors that are automatically called when objects are created
- Destructors that are automatically called at program end
- Encapsulation with private and public field modifiers
- Methods (procedures) that can be called on objects
- while-do loops
- for-do loops (`to` and `downto`)
- `break` and `continue`
- User-defined global procedures
- User-defined global functions with return via function-name assignment
- Static routine scoping: routines execute with global visibility + their own local scopes
- Input functionality using readln() for reading integers
- Output functionality using writeln() for printing integers

### Bonus Features
- Inheritance where child classes can inherit from parent classes
- Interfaces with runtime enforcement - classes must implement all interface methods
- Simple constant propagation (constant-folding of arithmetic subexpressions) with optimized AST print
- Formal parameter passing in procedures/functions with correct local scoping

## Project Structure
- src/main/antlr4/delphi.g4 - The ANTLR4 grammar file
- src/main/java/Interpreter.java - The interpreter implementation
- src/main/java/Main.java - The main entry point
- tests/test1.pas - Test for basic class features and I/O
- tests/test2.pas - Test for encapsulation and destructors
- tests/test3.pas - Test for inheritance
- tests/test5.pas - Test for multiple objects and arithmetic
- tests/test6.pas - Test for multiple fields in a class
- tests/test7.pas - Test for private field access control
- tests/test_private_fail.pas - Negative test showing private access error
- tests/test_main_block.pas - Test for Pascal-style main block with trailing dot
- tests/test_params.pas - Test for parameter passing in constructors and methods
- tests/test_interface.pas - Test for interface implementation
- tests/test_interface_fail.pas - Negative test showing interface enforcement
- tests/test8_loops.pas - Test for while/for loops with break and continue
- tests/test9_routines.pas - Test for user-defined procedures and functions
- tests/test10_static_scope.pas - Test for static scoping in routine calls
- tests/test_break_fail.pas - Negative test for break/continue outside loops
- tests/test_bonus_constprop.pas - Bonus test for constant propagation and optimized AST output
- tests/test_bonus_formal_params.pas - Bonus test for formal parameter passing in procedures/functions
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

### test5.pas
Tests multiple objects with arithmetic operations.
- Input: None
- Output: 20, 20

### test6.pas
Tests multiple fields in a class.
- Input: Two integers (e.g., 10 then 20)
- Output: 10, 20

### test7.pas
Tests private field access control with comments showing blocked access.
- Input: None
- Output: 150

### test_private_fail.pas
Negative test demonstrating runtime error when accessing private fields from outside.
- Input: None
- Output: Runtime error (private field access violation)

### test_main_block.pas
Tests Pascal-style main block with begin...end. syntax.
- Input: None
- Output: 99

### test_params.pas
Tests parameter passing in constructors and methods.
- Input: None
- Output: 10, 15, 0

### test_interface.pas
Tests interface declaration and implementation with enforcement.
- Input: None
- Output: 100, 0

### test_interface_fail.pas
Negative test demonstrating error when class doesn't implement required interface methods.
- Input: None
- Output: Runtime error (missing interface method)

### test8_loops.pas
Tests `while`, `for to`, `for downto`, `break`, and `continue`.
- Input: None
- Output: 7, 1, 2, 3, 3, 2, 1

### test9_routines.pas
Tests user-defined procedure/function declarations and calls.
- Input: None
- Output: 15, 5

### test10_static_scope.pas
Tests routine static scoping by showing routine sees global `x`, not caller-local `x`.
- Input: None
- Output: 10

### test_break_fail.pas
Negative test for `break` outside loop.
- Input: None
- Output: Runtime error (`break/continue used outside loop`)

### test_bonus_constprop.pas
Bonus test for constant propagation.
- Input: None
- Output: 42, 48
- With AST print enabled, optimized AST includes:
  - `v := 42;`
  - `x := v + 6;`

### test_bonus_formal_params.pas
Bonus test for formal parameter passing in procedures/functions.
- Input: None
- Output: 11, 11

## Running Individual Tests

For tests that require input, provide it via echo:
```
echo "42" | mvn exec:java -Dexec.args="tests/test1.pas"
```

For tests without input:
```
mvn exec:java -Dexec.args="tests/test2.pas"
mvn exec:java -Dexec.args="tests/test5.pas"
mvn exec:java -Dexec.args="tests/test_params.pas"
mvn exec:java -Dexec.args="tests/test8_loops.pas"
mvn exec:java -Dexec.args="tests/test9_routines.pas"
mvn exec:java -Dexec.args="tests/test10_static_scope.pas"
mvn exec:java -Dexec.args="tests/test_bonus_formal_params.pas"
mvn exec:java -Dexec.args="tests/test_bonus_constprop.pas"
```

To print the optimized AST (constant-folded expressions):
```
mvn exec:java -Dexec.args="tests/test_bonus_constprop.pas" -DprintAst=true
```

## Notes
- Fields can be marked as private or public (default is public if not specified)
- Private fields cannot be accessed from outside the class
- The destructor is called automatically at the end of program execution for all created objects
- Inheritance copies parent fields and methods to child classes at class definition time
- Parameter passing is supported for constructors and methods
- Parameter passing is supported for global procedures/functions as well
- Optional Pascal-style main block is supported: begin ... end. (with optional trailing dot)
- Top-level declarations (`interface`, `class`, `procedure`, `function`) should appear before executable statements
- Delphi-style declarations are supported (`TypeName = class(...)`, `InterfaceName = interface`)
