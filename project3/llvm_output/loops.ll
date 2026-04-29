; LLVM IR for loops test
; Generated: 2026-04-29

declare i32 @printf(i8*, ...)
declare i32 @scanf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define i32 @main() {
  %i = alloca i32
  store i32 0, i32* %i
  
  ; while 1 do begin writeln(7); break; end
  br label %while_start_0
  
  while_start_0:
    %cond0 = icmp eq i32 1, 1
    br i1 %cond0, label %while_body_0, label %while_end_0
  
  while_body_0:
    call i32 (i8*, ...) @printf(i8* @str0, i32 7)
    br label %while_end_0
  
  while_end_0:
  
  ; for i := 1 to 3 do begin writeln(i); end
  store i32 1, i32* %i
  br label %for_test_1
  
  for_test_1:
    %i_val1 = load i32, i32* %i
    %cond1 = icmp sle i32 %i_val1, 3
    br i1 %cond1, label %for_body_1, label %for_end_1
  
  for_body_1:
    %i_val2 = load i32, i32* %i
    call i32 (i8*, ...) @printf(i8* @str0, i32 %i_val2)
    %i_val3 = load i32, i32* %i
    %i_next1 = add i32 %i_val3, 1
    store i32 %i_next1, i32* %i
    br label %for_test_1
  
  for_end_1:
  
  ; for i := 3 downto 1 do begin writeln(i); end
  store i32 3, i32* %i
  br label %for_test_2
  
  for_test_2:
    %i_val4 = load i32, i32* %i
    %cond2 = icmp sge i32 %i_val4, 1
    br i1 %cond2, label %for_body_2, label %for_end_2
  
  for_body_2:
    %i_val5 = load i32, i32* %i
    call i32 (i8*, ...) @printf(i8* @str0, i32 %i_val5)
    %i_val6 = load i32, i32* %i
    %i_next2 = sub i32 %i_val6, 1
    store i32 %i_next2, i32* %i
    br label %for_test_2
  
  for_end_2:
  
  ret i32 0
}
