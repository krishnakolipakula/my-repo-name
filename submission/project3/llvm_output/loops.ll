; LLVM IR for loop control flow test
; Input: while loop, for loop (to), for loop (downto)
; Expected Output: 7 1 2 3 3 2 1

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
entry:
  %i = alloca i32
  
  ; writeln(7)
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 7)
  
  ; while i = 1 do begin writeln(i); i := 0; end
  store i32 1, i32* %i
  br label %while_start
  
while_start:
  %i_val_1 = load i32, i32* %i
  %cmp_1 = icmp eq i32 %i_val_1, 1
  %cmp_1_i32 = zext i1 %cmp_1 to i32
  %cmp_1_i1 = icmp ne i32 %cmp_1_i32, 0
  br i1 %cmp_1_i1, label %while_body, label %while_end
  
while_body:
  %i_val_2 = load i32, i32* %i
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %i_val_2)
  store i32 0, i32* %i
  br label %while_start
  
while_end:
  ; for i := 1 to 3 do writeln(i)
  store i32 1, i32* %i
  br label %for_to_test
  
for_to_test:
  %i_val_3 = load i32, i32* %i
  %cmp_to = icmp sle i32 %i_val_3, 3
  br i1 %cmp_to, label %for_to_body, label %for_to_end
  
for_to_body:
  %i_val_4 = load i32, i32* %i
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %i_val_4)
  %i_val_5 = load i32, i32* %i
  %i_next_1 = add i32 %i_val_5, 1
  store i32 %i_next_1, i32* %i
  br label %for_to_test
  
for_to_end:
  ; for i := 3 downto 1 do writeln(i)
  store i32 3, i32* %i
  br label %for_downto_test
  
for_downto_test:
  %i_val_6 = load i32, i32* %i
  %cmp_downto = icmp sge i32 %i_val_6, 1
  br i1 %cmp_downto, label %for_downto_body, label %for_downto_end
  
for_downto_body:
  %i_val_7 = load i32, i32* %i
  call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @str0, i32 0, i32 0), i32 %i_val_7)
  %i_val_8 = load i32, i32* %i
  %i_next_2 = sub i32 %i_val_8, 1
  store i32 %i_next_2, i32* %i
  br label %for_downto_test
  
for_downto_end:
  ret i32 0
}
