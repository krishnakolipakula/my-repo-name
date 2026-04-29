; LLVM IR for Delphi/Pascal
; Generated: Wed Apr 29 11:40:06 EDT 2026

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

define i32 @main() {
  %v0 = alloca i32
  store i32 0, i32* %v0
  call i32 (i8*, ...) @printf(i8* @str0, i32 7)
  store i32 1, i32* %v0
  br label %while_start_0
while_start_0:
  %v1 = load i32, i32* %v0
  %v3 = icmp eq i32 %v1, 1
  %v2 = zext i1 %v3 to i32
  %v4 = icmp ne i32 %v2, 0
  br i1 %v4, label %while_body_1, label %while_end_2
while_body_1:
  %v5 = load i32, i32* %v0
  call i32 (i8*, ...) @printf(i8* @str1, i32 %v5)
  store i32 0, i32* %v0
  br label %while_start_0
while_end_2:
  %v6 = alloca i32
  store i32 1, i32* %v6
  br label %for_test_3
for_test_3:
  %v7 = load i32, i32* %v6
  %v8 = icmp sle i32 %v7, 3
  br i1 %v8, label %for_body_4, label %for_end_5
for_body_4:
  %v9 = load i32, i32* %v6
  call i32 (i8*, ...) @printf(i8* @str2, i32 %v9)
  %v11 = load i32, i32* %v6
  %v10 = add i32 %v11, 1
  store i32 %v10, i32* %v6
  br label %for_test_3
for_end_5:
  %v12 = alloca i32
  store i32 3, i32* %v12
  br label %for_test_6
for_test_6:
  %v13 = load i32, i32* %v12
  %v14 = icmp sge i32 %v13, 1
  br i1 %v14, label %for_body_7, label %for_end_8
for_body_7:
  %v15 = load i32, i32* %v12
  call i32 (i8*, ...) @printf(i8* @str3, i32 %v15)
  %v17 = load i32, i32* %v12
  %v16 = sub i32 %v17, 1
  store i32 %v16, i32* %v12
  br label %for_test_6
for_end_8:
  ret i32 0
}

@str0 = private constant [4 x i8] c"%d\0A\00"
@str1 = private constant [4 x i8] c"%d\0A\00"
@str2 = private constant [4 x i8] c"%d\0A\00"
@str3 = private constant [4 x i8] c"%d\0A\00"
