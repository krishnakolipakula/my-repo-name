; LLVM IR for procedures and functions
; Generated: 2026-04-29

declare i32 @printf(i8*, ...)

@str0 = private constant [4 x i8] c"%d\0A\00"

define void @addToTotal(i32 %value) {
  ; In a real scenario, this would modify a global variable
  ; For now, this is simplified
  ret void
}

define i32 @add(i32 %a, i32 %b) {
  %result = add i32 %a, %b
  ret i32 %result
}

define i32 @main() {
  %total = alloca i32
  store i32 0, i32* %total
  
  ; total := 0
  store i32 0, i32* %total
  
  ; addToTotal(10)
  call void @addToTotal(i32 10)
  
  ; addToTotal(5)
  call void @addToTotal(i32 5)
  
  ; writeln(total)
  %total_val = load i32, i32* %total
  call i32 (i8*, ...) @printf(i8* @str0, i32 %total_val)
  
  ; writeln(add(2, 3))
  %add_result = call i32 @add(i32 2, i32 3)
  call i32 (i8*, ...) @printf(i8* @str0, i32 %add_result)
  
  ret i32 0
}
