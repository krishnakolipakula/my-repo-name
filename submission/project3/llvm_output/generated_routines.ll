; LLVM IR for Delphi/Pascal
; Generated: Wed Apr 29 11:40:06 EDT 2026

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

define i32 @add(i32 %p0, i32 %p1) {
  %v0 = alloca i32
  store i32 0, i32* %v0
  %v1 = alloca i32
  store i32 %p0, i32* %v1
  %v2 = alloca i32
  store i32 %p1, i32* %v2
  %v3 = load i32, i32* %v1
  %v4 = load i32, i32* %v2
  %v5 = add i32 %v3, %v4
  store i32 %v5, i32* %v0
  %v6 = load i32, i32* %v0
  ret i32 %v6
}

define i32 @multiply(i32 %p0, i32 %p1) {
  %v7 = alloca i32
  store i32 0, i32* %v7
  %v8 = alloca i32
  store i32 %p0, i32* %v8
  %v9 = alloca i32
  store i32 %p1, i32* %v9
  %v10 = load i32, i32* %v8
  %v11 = load i32, i32* %v9
  %v12 = mul i32 %v10, %v11
  store i32 %v12, i32* %v7
  %v13 = load i32, i32* %v7
  ret i32 %v13
}

define i32 @main() {
  %v14 = alloca i32
  store i32 0, i32* %v14
  %v15 = call i32 @add(i32 2, i32 3)
  store i32 %v15, i32* %v14
  %v16 = load i32, i32* %v14
  call i32 (i8*, ...) @printf(i8* @str0, i32 %v16)
  %v17 = call i32 @multiply(i32 5, i32 3)
  store i32 %v17, i32* %v14
  %v18 = load i32, i32* %v14
  call i32 (i8*, ...) @printf(i8* @str1, i32 %v18)
  ret i32 0
}

@str0 = private constant [4 x i8] c"%d\0A\00"
@str1 = private constant [4 x i8] c"%d\0A\00"
