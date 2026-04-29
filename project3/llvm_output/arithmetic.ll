; LLVM IR for arithmetic and expressions
; Generated: 2026-04-29

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
  %a = alloca i32
  %b = alloca i32
  %c = alloca i32
  
  ; a := 10
  store i32 10, i32* %a
  
  ; b := 5
  store i32 5, i32* %b
  
  ; c := a + b
  %a_val = load i32, i32* %a
  %b_val = load i32, i32* %b
  %sum = add i32 %a_val, %b_val
  store i32 %sum, i32* %c
  
  ; writeln(c)
  %c_val = load i32, i32* %c
  call i32 (i8*, ...) @printf(i8* @str0, i32 %c_val)
  
  ; d := a * b - 3
  %mul = mul i32 %a_val, %b_val
  %three = sub i32 %mul, 3
  call i32 (i8*, ...) @printf(i8* @str0, i32 %three)
  
  ; e := (a + b) * 2
  %add2 = add i32 %a_val, %b_val
  %mult2 = mul i32 %add2, 2
  call i32 (i8*, ...) @printf(i8* @str0, i32 %mult2)
  
  ret i32 0
}
