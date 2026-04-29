; LLVM IR for simple arithmetic test
; Input: x := 5; y := 3; writeln(x + y)
; Expected Output: 8

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
  %x = alloca i32
  %y = alloca i32
  store i32 5, i32* %x
  store i32 3, i32* %y
  
  %x_val = load i32, i32* %x
  %y_val = load i32, i32* %y
  %sum = add i32 %x_val, %y_val
  
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %sum)
  
  ret i32 0
}
