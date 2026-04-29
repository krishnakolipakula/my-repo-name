; LLVM IR for arithmetic operations test
; Input: a := 10; b := 5; compute: a+b, a*b-b, a*b/5*3
; Expected Output: 15 45 30

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
  %a = alloca i32
  %b = alloca i32
  %c = alloca i32
  %d = alloca i32
  
  store i32 10, i32* %a
  store i32 5, i32* %b
  store i32 0, i32* %c
  store i32 0, i32* %d
  
  ; c := a + b
  %a_val_1 = load i32, i32* %a
  %b_val_1 = load i32, i32* %b
  %sum = add i32 %a_val_1, %b_val_1
  store i32 %sum, i32* %c
  %c_val_1 = load i32, i32* %c
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %c_val_1)
  
  ; d := a * b - b
  %a_val_2 = load i32, i32* %a
  %b_val_2 = load i32, i32* %b
  %mul1 = mul i32 %a_val_2, %b_val_2
  %b_val_3 = load i32, i32* %b
  %sub1 = sub i32 %mul1, %b_val_3
  store i32 %sub1, i32* %d
  %d_val_1 = load i32, i32* %d
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %d_val_1)
  
  ; d := a * b / 5 * 3
  %a_val_3 = load i32, i32* %a
  %b_val_4 = load i32, i32* %b
  %mul2 = mul i32 %a_val_3, %b_val_4
  %div1 = sdiv i32 %mul2, 5
  %mul3 = mul i32 %div1, 3
  store i32 %mul3, i32* %d
  %d_val_2 = load i32, i32* %d
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %d_val_2)
  
  ret i32 0
}
