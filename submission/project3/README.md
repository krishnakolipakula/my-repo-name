# Project 3: Delphi/Pascal to LLVM IR Compiler

## Team Members

Krishna Chaitanya Kolipakula (UFID: 94059870)
Karthikeya Ruthvik Pakki (UFID: 52291889)

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

From the submission/project3 directory, you can either use the pre-built JAR file that's already included, or rebuild it yourself.

To use the pre-built JAR, simply run:

java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler tests/test_simple.pas llvm_output/output.ll

This reads the Pascal file and writes the generated LLVM IR to output.ll.

To rebuild the compiler from source, use Maven:

mvn clean package

This creates the JAR file in the target directory. If you prefer, you can also build and run directly with Maven without creating a JAR:

mvn exec:java -Dexec.mainClass=Compiler -Dexec.args="tests/test_simple.pas llvm_output/generated.ll"

We also included a helper script called regen_ll.sh that rebuilds everything and regenerates all the test LLVM IR files at once. Just run:

chmod +x regen_ll.sh
./regen_ll.sh

## Test Programs

We provide four test Pascal programs to demonstrate the compiler's capabilities.

**test_simple.pas:** A basic test that adds two numbers and prints the result. It declares two integer variables, assigns 5 to one and 3 to the other, then prints their sum. The expected output is 8.

**test_loops.pas:** Tests loop functionality. It prints 7, then uses a for loop to count from 1 to 3, then counts back down from 3 to 1. The expected output is: 7 1 2 3 3 2 1

**test_arithmetic.pas:** Demonstrates more complex arithmetic with multiple operations. It adds 10 and 5 to get 15, multiplies and subtracts to get 45, then performs a chain of operations to get 30. Expected output: 15 45 30

**test_routines.pas:** Shows function definitions and calls. It defines an add function that takes two integers and returns their sum, then calls it twice with different arguments. Expected output: 5 15

## Generating LLVM IR

Once you have the compiler JAR built, you can generate LLVM IR from any Pascal program:

To compile test_simple.pas, run:

java -cp target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar Compiler tests/test_simple.pas llvm_output/my_output.ll

The first argument is the input Pascal file, and the second is where to write the generated LLVM IR. The output will be a valid LLVM IR file that can be compiled with standard LLVM tools.

## Compiling Generated IR to Native Code

Once you have a LLVM IR file (a .ll file), you can compile it to a native executable using clang:

clang output.ll -o my_program

Then run the resulting executable:

./my_program

The output should match the expected results from the Pascal program.

To test all four programs at once, you can use a loop:

for f in llvm_output/generated_*.ll; do
  base=$(basename "$f" .ll)
  clang "$f" -o "$base"_exe
  echo "Running $base:"
  ./"$base"_exe
done

## Compiling to WebAssembly

We also added support for compiling the generated LLVM IR to WebAssembly binaries. The pre-built .wasm files are already included in the llvm_output directory (generated_simple.wasm, generated_loops.wasm, etc.) and were automatically built by our GitHub Actions CI workflow.

If you want to build WebAssembly files locally, you'll need LLVM tools installed. First convert the LLVM IR to an object file:

llc -mtriple=wasm32-wasi -filetype=obj -o program.o program.ll

Then link it to create a WebAssembly module:

wasm-ld --no-entry --allow-undefined --export-all -o program.wasm program.o

The resulting .wasm file is a valid WebAssembly module that can be loaded and executed in a web browser.

## Using the Browser Viewer

We included a browser-based LLVM IR viewer in index.html. To use it, open the file in any modern web browser. If you encounter issues with loading local files, you can start a simple HTTP server:

python3 -m http.server 8000

Then visit http://localhost:8000/index.html in your browser.

The viewer allows you to:

Load LLVM IR files or WebAssembly modules from the llvm_output directory. Just enter the file path and click Load.

Analyze the structure of the IR, including the functions, basic blocks, and instructions it contains.

Simulate execution to trace through how the IR operates and see how memory and registers change.

For WebAssembly files, you can execute them directly in the browser and see the output captured from any printf calls.

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
