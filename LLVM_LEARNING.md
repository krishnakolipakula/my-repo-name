# LLVM IR Learning Guide

## Basic LLVM IR Patterns

### 1. Function Declaration
```llvm
declare i32 @printf(i8* noundef, ...)  ; External function

define i32 @main() {
    ; function body
    ret i32 0
}
```

### 2. Global Variables & Constants
```llvm
@global_var = global i32 42
@str = private constant [14 x i8] c"Hello World\0A\00"
```

### 3. Local Variables (Stack Allocation)
```llvm
%var = alloca i32              ; Allocate space for an i32
store i32 10, i32* %var       ; Store value
%value = load i32, i32* %var  ; Load value
```

### 4. Arithmetic Operations
```llvm
%result = add i32 %a, %b      ; Addition
%result = sub i32 %a, %b      ; Subtraction
%result = mul i32 %a, %b      ; Multiplication
%result = sdiv i32 %a, %b     ; Signed division
%result = srem i32 %a, %b     ; Remainder
```

### 5. Comparisons & Branches
```llvm
%cond = icmp slt i32 %a, %b   ; Compare a < b
br i1 %cond, label %if_true, label %if_false
```

### 6. While Loop
```llvm
loop_start:
  %cond = icmp slt i32 %i, 10
  br i1 %cond, label %loop_body, label %loop_exit
  
loop_body:
  ; loop code here
  %i_next = add i32 %i, 1
  store i32 %i_next, i32* %i_ptr
  br label %loop_start
  
loop_exit:
  ; continue after loop
```

### 7. Function Calls
```llvm
%result = call i32 @add_func(i32 5, i32 3)
call void @printf(i8* @str)
```

### 8. Printf for I/O
```llvm
@.str_int = private constant [4 x i8] c"%d\0A\00"
declare i32 @printf(i8* noundef, ...)

; Usage:
call i32 (i8*, ...) @printf(i8* @.str_int, i32 %value)
```

### 9. Complete Simple Example
```llvm
@.str_int = private constant [4 x i8] c"%d\0A\00"
declare i32 @printf(i8* noundef, ...)

define i32 @main() {
    %a = alloca i32
    %b = alloca i32
    
    store i32 5, i32* %a
    store i32 3, i32* %b
    
    %a_val = load i32, i32* %a
    %b_val = load i32, i32* %b
    %sum = add i32 %a_val, %b_val
    
    call i32 (i8*, ...) @printf(i8* @.str_int, i32 %sum)
    
    ret i32 0
}
```

## Key Concepts
- **%name**: Local register (temporary value)
- **@name**: Global identifier
- **i32, i64**: Integer types (32-bit, 64-bit)
- **i32***: Pointer to i32
- **alloca**: Allocate space on stack
- **store/load**: Write/read from memory
- **label**: Jump target
- **br**: Unconditional or conditional branch
- **icmp**: Integer comparison
- **call**: Function invocation
- **ret**: Return from function

## Compilation Pipeline
```
.pas file → Parser → AST → LLVM IR (.ll) → llc → Object (.o) → linker → Executable
```

For WASM:
```
.ll file → llc → .wasm → HTML/JS loader → Browser execution
```
