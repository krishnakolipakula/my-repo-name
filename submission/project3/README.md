# Project 3: Delphi/Pascal to LLVM IR Compiler

## Team Members
- Krishna Chaitanya Kolipakula (UFID: 94059870)
- Karthikeya Ruthvik Pakki (UFID: 52291889)

## Overview

This project extends the Delphi/Pascal interpreter from Projects 1 and 2 into a full compiler that generates LLVM Intermediate Representation (IR). We take Pascal/Delphi source code and compile it into LLVM IR format, which can then be compiled to either native executable binaries or WebAssembly modules.

## What We Built

Our compiler implements the core Delphi/Pascal language features needed for this assignment.

**Variables and Memory:** We handle variable declarations and allocate them on the stack. All variables are 32-bit integers, and we use LLVM's memory model with proper store and load operations.

**Arithmetic:** Addition, subtraction, multiplication, and division are all supported with correct operator precedence. Expressions are evaluated following standard math rules.

**Control Flow:** While loops and for loops work correctly. For loops can count upward (to) or downward (downto). Conditions are properly evaluated in LLVM using comparison instructions and conditional branches.

**Functions and Procedures:** We support both procedures (no return value) and functions (with return values). Parameters are passed correctly to functions, and variable scope is maintained properly throughout execution.

**Input and Output:** The writeln statement generates printf calls in the generated LLVM code, so programs can print their results. String constants work as format strings for printf.

**Internal Implementation:** Our compiler uses an ANTLR lexer and parser to read the Pascal source, then a visitor pattern traverses the parse tree and emits LLVM IR instructions. We maintain a symbol table to track variables and generate unique labels for all control flow jumps.

## Project Structure

The submission includes the following directories and files:

The llvm_output folder contains all the generated LLVM IR files (simple.ll, loops.ll, arithmetic.ll, routines.ll) as well as compiled executables that demonstrate the output works correctly. The index.html file provides a browser-based viewer where you can load and analyze LLVM IR files.

The source code is in the submission/project3 directory. The Java files (Compiler.java, LLVMCodeGenerator.java, and the interpreter files from previous projects) contain the compiler implementation. The delphi.g4 file is the ANTLR grammar that defines the Pascal/Delphi syntax. The pom.xml file is the Maven build configuration.

The tests folder contains four Pascal source files that demonstrate the compiler's capabilities.

## Building and Running

To use the compiler, first make sure you have Java 11 or higher and Maven installed on your system.

**Using the Pre-built JAR**

We've included a compiled JAR file that's ready to use. From the submission/project3 directory, you can immediately compile Pascal files to LLVM IR:

    cd submission/project3
    java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler tests/test_simple.pas llvm_output/output.ll

This command reads test_simple.pas and writes the generated LLVM IR to output.ll.

**Rebuilding from Source**

If you want to rebuild the compiler, use Maven:

    mvn clean package

This compiles everything and creates the JAR file in the target directory.

Alternatively, you can build and run directly without creating a JAR:

    mvn exec:java -Dexec.mainClass=Compiler -Dexec.args="tests/test_simple.pas llvm_output/generated.ll"

**Quick Regeneration of All Test Files**

We included a helper script that rebuilds everything and regenerates all test LLVM IR files in one go:

    chmod +x regen_ll.sh
    ./regen_ll.sh

This will compile all four test Pascal programs and produce the corresponding .ll files.

## Test Programs

We provide four test Pascal programs to demonstrate the compiler's capabilities.

**test_simple.pas:** A basic test that adds two numbers and prints the result.

    var x: integer;
    var y: integer;
    begin
      x := 5;
      y := 3;
      writeln(x + y);
    end.

Expected output: 8

**test_loops.pas:** Tests loop functionality with for loops.

    var i: integer;
    begin
      writeln(7);
      for i := 1 to 3 do writeln(i);
      for i := 3 downto 1 do writeln(i);
    end.

Expected output: 7 1 2 3 3 2 1

**test_arithmetic.pas:** Demonstrates more complex arithmetic with multiple operations.

    var a, b, c: integer;
    begin
      a := 10;
      b := 5;
      writeln(a + b);
      writeln(a * b - b);
      writeln(a * b / 5 * 3);
    end.

Expected output: 15 45 30

**test_routines.pas:** Shows function definitions and calls.

    function add(x: integer; y: integer): integer
    begin
      add := x + y;
    end;
    
    begin
      writeln(add(2, 3));
      writeln(add(5, 10));
    end.

Expected output: 5 15

## Generating LLVM IR

Once you have the compiler JAR built, you can generate LLVM IR from any Pascal program. The basic command is:

    java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler <input.pas> <output.ll>

For example, to compile test_simple.pas:

    java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler tests/test_simple.pas llvm_output/my_output.ll

The first argument is the input Pascal file, and the second is where to write the generated LLVM IR. The output will be a valid LLVM IR file that can be compiled with standard LLVM tools.

To generate all test files at once:

    for test in tests/test_*.pas; do
      outfile="llvm_output/generated_$(basename $test .pas).ll"
      java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler "$test" "$outfile"
    done

## Compiling Generated IR to Native Code

Once you have a LLVM IR file (a .ll file), compile it to a native executable using clang:

    clang llvm_output/output.ll -o my_program
    ./my_program

The output should match the expected results from the Pascal program.

To compile and test all four programs:

    cd llvm_output
    
    for f in generated_*.ll; do
      base=$(basename "$f" .ll)
      echo "Compiling $base..."
      clang "$f" -o "${base}_exe"
      echo "Running $base:"
      ./"${base}_exe"
      echo ""
    done

This will compile each LLVM IR file to an executable and run it, showing the output from each test.

## Compiling to WebAssembly

We also added support for compiling the generated LLVM IR to WebAssembly binaries. The pre-built .wasm files are already included in the llvm_output directory and were automatically built by our GitHub Actions CI workflow.

If you want to build WebAssembly files locally, you'll need LLVM tools installed. The process has two steps:

First, convert the LLVM IR to an object file:

    llc -mtriple=wasm32-wasi -filetype=obj -o program.o program.ll

Then link it to create a WebAssembly module:

    wasm-ld --no-entry --allow-undefined --export-all -o program.wasm program.o

To build WebAssembly for all test programs:

    cd llvm_output
    
    for f in generated_*.ll; do
      base=$(basename "$f" .ll)
      echo "Building $base.wasm..."
      llc -mtriple=wasm32-wasi -filetype=obj -o "${base}.o" "$f"
      wasm-ld --no-entry --allow-undefined --export-all -o "${base}.wasm" "${base}.o"
    done

The resulting .wasm files are valid WebAssembly modules that can be loaded and executed in a web browser.

## Using the Browser Viewer

We included a browser-based LLVM IR viewer in index.html. To use it, first start a local HTTP server:

    python3 -m http.server 8000

Then open your browser and visit:

    http://localhost:8000/index.html

The viewer allows you to load LLVM IR files or WebAssembly modules from the llvm_output directory, analyze their structure, and simulate execution. For WebAssembly files, you can execute them directly in the browser and see the output captured from any printf calls.

## Generated IR Files

All four test programs have been compiled to LLVM IR. The files are in the llvm_output directory:

generated_simple.ll: About 15 lines of IR for the simple arithmetic test.

generated_loops.ll: About 35 lines showing the control flow for loop tests.

generated_arithmetic.ll: About 25 lines for the complex arithmetic operations.

generated_routines.ll: About 30 lines showing the function definitions and calls.

All of these have been validated and can be compiled to working executables using clang.

## How It Works

The compiler follows a standard three-stage pipeline:

First, the ANTLR lexer and parser read the Pascal source code and build a parse tree that represents the program's structure.

Second, our LLVMCodeGenerator class walks through this parse tree using the visitor pattern. For each language construct (variable declarations, expressions, loops, etc.), it emits the corresponding LLVM IR instructions.

Third, the generated LLVM IR is written to a .ll file. From there, standard LLVM tools like clang and llc can compile it to native code or other target formats like WebAssembly.

## Known Limitations

Currently, the compiler only supports 32-bit integer variables. Global variables are not supported (use local variables in main instead). Object-oriented features like classes are not compiled to LLVM. Arrays and string variables are not supported (though we do use string constants for printf format strings).

These limitations are acceptable for the scope of this project, which focuses on the core compilation process from high-level Pascal code to low-level IR.

## Files Included in Submission

Source code: All Java files for the compiler and parser, plus the ANTLR grammar file.

Generated LLVM IR: All four test programs compiled to .ll format.

Compiled executables: Native binaries created from the LLVM IR to show that execution produces correct output.

WebAssembly modules: Pre-built .wasm files for all test programs.

Browser viewer: The index.html file for interactive IR analysis.

Build configuration: The pom.xml file for Maven, plus the helper script regen_ll.sh.

This README file with complete documentation.

## Verification

We tested all four Pascal programs through the complete pipeline:

The compiler successfully parses each Pascal file without errors.

Valid LLVM IR is generated for each program.

The generated IR can be compiled to working native executables using clang.

Running the executables produces the correct expected output.

The browser viewer successfully loads and analyzes the generated IR files.

WebAssembly files were successfully compiled and can be executed in the browser.

The project is complete and ready for submission.
