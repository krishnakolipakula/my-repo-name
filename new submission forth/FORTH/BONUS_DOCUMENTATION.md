# Bonus Feature: User-Defined Functions

## Overview

This implementation adds full support for user-defined functions in FORTH, following the standard FORTH syntax for function definitions.

## Syntax

```forth
: FUNCTION_NAME body... ;
```

- `:` - Starts a function definition
- `FUNCTION_NAME` - The name of the function (must be a valid identifier)
- `body...` - Sequence of FORTH operations (built-in or user-defined)
- `;` - Ends the function definition

## Examples

### Simple Function
```forth
: SQUARE DUP * ;
5 SQUARE .
```
Output: `25`

### Multiple Functions
```forth
: DOUBLE 2 * ;
: SQUARE DUP * ;
3 DOUBLE SQUARE .
```
Output: `36` (3 * 2 = 6, then 6 * 6 = 36)

### Function Composition
```forth
: DOUBLE 2 * ;
: QUAD DOUBLE DOUBLE ;
3 QUAD .
```
Output: `12` (3 * 2 = 6, then 6 * 2 = 12)

### Complex Function
```forth
: CUBE DUP DUP * * ;
4 CUBE .
```
Output: `64` (4 * 4 * 4)

## Implementation Architecture

### Key Design Decisions

1. **Function Dictionary**: Used `Data.Map String [Val]` to store function definitions
   - Key: Function name
   - Value: List of tokens representing the function body

2. **Extended State**: Changed interpreter state from `([Val], String)` to `([Val], String, FuncDict)`
   - Stack: `[Val]`
   - Output: `String`
   - Function Dictionary: `FuncDict`

3. **Two-Phase Processing**:
   - **Parse Phase**: Extract all function definitions and build dictionary
   - **Execute Phase**: Process remaining tokens with function dictionary available

#### Key Functions

**parseFunctions**: Scans token list for `: NAME ... ;` patterns
- Extracts function name and body
- Stores in dictionary
- Returns remaining tokens and updated dictionary

**evalF**: Enhanced to check function dictionary
- If identifier matches user-defined function, expand its body
- Otherwise, use built-in evalOut
- Maintains function dictionary through execution

**interpret**: Orchestrates the process
- Tokenize input
- Parse function definitions
- Execute remaining tokens with function dictionary

## Test Coverage

### Unit Tests (InterpretSpec.hs)
- Basic function definition and usage
- Multiple function definitions
- Function composition
- Functions with output operations
- Functions calling other functions

### Functional Tests
- **t11.4TH**: SQUARE function
- **t12.4TH**: Multiple functions (DOUBLE and SQUARE)
- **t13.4TH**: Function composition (QUAD)
- **t14.4TH**: CUBE function with multiple outputs
- **t15.4TH**: Functions with string operations

## Edge Cases Handled

1. **Empty Function Body**: Allowed (function does nothing)
2. **Function Redefinition**: First definition wins (no redefinition)
3. **Undefined Function**: Treated as identifier (pushed to stack)
4. **Nested Definitions**: Not supported (would require more complex parsing)
5. **Recursive Functions**: Supported through dictionary lookup

## Conclusion

This implementation provides a clean, functional approach to user-defined functions in FORTH while respecting Haskell's immutability constraints. The two-phase design (parse then execute) simplifies the implementation while maintaining full functionality for function definition and composition.
