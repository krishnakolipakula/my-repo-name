# FORTH Interpreter

A FORTH interpreter implementation in Haskell with support for basic arithmetic operations, stack manipulation, and string operations.

## Prerequisites

- GHC (Glasgow Haskell Compiler)
- Cabal (Haskell package manager)

## Installation

Make sure you are inside the FORTH directory and install the required packages:

```bash
cabal install
cabal install flow
```

## Building the Project

To compile the code:

```bash
cabal build
```

## Running the Interpreter

To run the interpreter with a test file:

```bash
cabal run tests/t1.4TH
```

Or run the executable directly:

```bash
dist/build/FORTH/FORTH tests/t1.4TH
```

## Running Unit Tests

Run the HSpec unit tests using `runhaskell`:

```bash
runhaskell ValSpec.hs
runhaskell EvalSpec.hs
runhaskell InterpretSpec.hs
```

## Supported Operations

### User-Defined Functions (Bonus Feature)
Define custom functions using FORTH syntax:
```
: SQUARE DUP * ;
```
- `:` - Start function definition
- Function name (e.g., `SQUARE`)
- Function body (sequence of operations)
- `;` - End function definition

Functions can:
- Call built-in operations
- Call other user-defined functions
- Be used anywhere in the code after definition

Example:
```
: DOUBLE 2 * ;
: QUAD DOUBLE DOUBLE ;
3 QUAD .  ( outputs 12 )
```

### Arithmetic Operators
- `*` - Multiplication
- `+` - Addition
- `-` - Subtraction
- `/` - Division (integer division for integers, float division for floats)
- `^` - Power/Exponentiation

### Stack Operations
- `DUP` - Duplicate the top element of the stack

### Output Operations
- `.` - Print the top element of the stack
- `EMIT` - Print the ASCII character corresponding to the integer on top of stack
- `CR` - Print a newline

### String Operations
- `STR` - Convert any value to a string
- `CONCAT2` - Concatenate two strings from the stack
- `CONCAT3` - Concatenate three strings from the stack

## Test Files

The project includes 15 functional test files (`t1.4TH` to `t15.4TH`) with corresponding expected output files (`t1.out` to `t15.out`):

### Basic Tests (t1-t10)
1. **t1.4TH** - Basic multiplication
2. **t2.4TH** - Addition and subtraction with CR
3. **t3.4TH** - Division and power operations
4. **t4.4TH** - EMIT function to print characters
5. **t5.4TH** - STR conversion and CONCAT2
6. **t6.4TH** - CONCAT3 with multiple strings
7. **t7.4TH** - DUP with arithmetic operations
8. **t8.4TH** - Float arithmetic operations
9. **t9.4TH** - Non-empty stack at end (demonstrates stack printing)
10. **t10.4TH** - Comprehensive test with multiple features

### Bonus Tests - User-Defined Functions (t11-t15)
11. **t11.4TH** - SQUARE function (DUP *)
12. **t12.4TH** - Multiple function definitions (DOUBLE and SQUARE)
13. **t13.4TH** - Function composition (QUAD calls DOUBLE twice)
14. **t14.4TH** - CUBE function with multiple outputs
15. **t15.4TH** - Functions with string operations

## Features Implemented

### 1. Stack Status Reporting
When the stack is not empty at the end of execution, the program prints:
- A message indicating the stack is not empty
- The contents of the stack

### 2. Extended Operators
All basic arithmetic operators (+, -, /, ^) have been implemented with proper type handling for both integers and floats.

### 3. String Operations
Full support for string manipulation including conversion from any type and concatenation.

### 4. Character Output
EMIT function allows printing ASCII characters by their numeric codes.

### 5. User-Defined Functions (Bonus)
Full support for user-defined functions following FORTH syntax:
- Function definitions using `: NAME ... ;` syntax
- Function dictionary stored and passed through interpreter state
- Functions can call other user-defined functions
- Functions can use all built-in operations
- Proper scoping and execution order

**Implementation Details:**
- Used `Data.Map` for function dictionary
- Extended interpreter state to include function definitions
- Parse phase separates function definitions from executable code
- Execution phase expands user-defined functions inline
- Supports recursive function composition

## Implementation Notes

### Type System
The interpreter supports four value types:
- `Integer Int` - Integer numbers
- `Real Float` - Floating-point numbers
- `Id String` - Identifiers/operators
- `Str String` - String values

### Stack Behavior
- Operations follow FORTH conventions (reverse Polish notation)
- Stack underflow errors are properly handled
- Type conversions are automatic where appropriate

### Edge Cases Handled
- Stack underflow for all operations
- Type mismatches (e.g., CONCAT on non-strings)
- Integer vs. float arithmetic (preserves integer type when possible)
- Empty stack at program end vs. non-empty stack

