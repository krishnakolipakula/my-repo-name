; LLVM IR for function test
; Input: functions add(x, y) and multiply(x, y)
; Expected Output: 5 15

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @add(i32 %p0, i32 %p1) {
entry:
  %ret_var = alloca i32
  store i32 0, i32* %ret_var
  
  ; add := x + y
  %sum = add i32 %p0, %p1
  store i32 %sum, i32* %ret_var
  
  %ret_val = load i32, i32* %ret_var
  ret i32 %ret_val
}

define i32 @multiply(i32 %p0, i32 %p1) {
entry:
  %ret_var = alloca i32
  store i32 0, i32* %ret_var
  
  ; multiply := x * y
  %prod = mul i32 %p0, %p1
  store i32 %prod, i32* %ret_var
  
  %ret_val = load i32, i32* %ret_var
  ret i32 %ret_val
}

define i32 @main() {
entry:
  %result = alloca i32
  
  ; result := add(2, 3)
  %call1 = call i32 @add(i32 2, i32 3)
  store i32 %call1, i32* %result
  %result_val_1 = load i32, i32* %result
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %result_val_1)
  
  ; result := multiply(5, 3)
  %call2 = call i32 @multiply(i32 5, i32 3)
  store i32 %call2, i32* %result
  %result_val_2 = load i32, i32* %result
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %result_val_2)
  
  ret i32 0
}
