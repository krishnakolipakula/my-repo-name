; LLVM IR for Delphi/Pascal
; Generated: Wed Apr 29 11:40:06 EDT 2026

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

define i32 @main() {
  %v0 = alloca i32
  store i32 0, i32* %v0
  %v1 = alloca i32
  store i32 0, i32* %v1
  %v2 = alloca i32
  store i32 0, i32* %v2
  %v3 = alloca i32
  store i32 0, i32* %v3
  store i32 10, i32* %v0
  store i32 5, i32* %v1
  store i32 0, i32* %v2
  store i32 0, i32* %v3
  %v4 = load i32, i32* %v0
  %v5 = load i32, i32* %v1
  %v6 = add i32 %v4, %v5
  store i32 %v6, i32* %v2
  %v7 = load i32, i32* %v2
  call i32 (i8*, ...) @printf(i8* @str0, i32 %v7)
  %v8 = load i32, i32* %v0
  %v9 = load i32, i32* %v1
  %v10 = mul i32 %v8, %v9
  %v11 = load i32, i32* %v1
  %v12 = sub i32 %v10, %v11
  store i32 %v12, i32* %v3
  %v13 = load i32, i32* %v3
  call i32 (i8*, ...) @printf(i8* @str1, i32 %v13)
  %v14 = load i32, i32* %v0
  %v15 = load i32, i32* %v1
  %v16 = mul i32 %v14, %v15
  %v17 = sdiv i32 %v16, 5
  %v18 = mul i32 %v17, 3
  store i32 %v18, i32* %v3
  %v19 = load i32, i32* %v3
  call i32 (i8*, ...) @printf(i8* @str2, i32 %v19)
  ret i32 0
}

@str0 = private constant [4 x i8] c"%d\0A\00"
@str1 = private constant [4 x i8] c"%d\0A\00"
@str2 = private constant [4 x i8] c"%d\0A\00"
