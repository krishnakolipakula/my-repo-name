; LLVM IR for Delphi/Pascal
; Generated: Wed Apr 29 11:40:06 EDT 2026

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

define i32 @main() {
  %v0 = alloca i32
  store i32 0, i32* %v0
  %v1 = alloca i32
  store i32 0, i32* %v1
  store i32 5, i32* %v0
  store i32 3, i32* %v1
  %v2 = load i32, i32* %v0
  %v3 = load i32, i32* %v1
  %v4 = add i32 %v2, %v3
  call i32 (i8*, ...) @printf(i8* @str0, i32 %v4)
  ret i32 0
}

@str0 = private constant [4 x i8] c"%d\0A\00"
