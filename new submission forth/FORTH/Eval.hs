module Eval where
-- This file contains definitions for functions and operators

import Val
import Data.Char (chr)

-- main evaluation function for operators and 
-- built-in FORTH functions with no output
-- takes a string and a stack and returns the stack
-- resulting from evaluation of the function
eval :: String -> [Val] -> [Val]
-- Multiplication
-- if arguments are integers, keep result as integer
eval "*" (Integer x: Integer y:tl) = Integer (x*y) : tl
-- if any argument is float, make result a float
eval "*" (x:y:tl) = (Real $ toFloat x * toFloat y) : tl 
-- any remaining cases are stacks too short
eval "*" _ = error("Stack underflow")

-- Addition
eval "+" (Integer x: Integer y:tl) = Integer (x+y) : tl
eval "+" (x:y:tl) = (Real $ toFloat x + toFloat y) : tl
eval "+" _ = error("Stack underflow")

-- Subtraction
eval "-" (Integer x: Integer y:tl) = Integer (y-x) : tl
eval "-" (x:y:tl) = (Real $ toFloat y - toFloat x) : tl
eval "-" _ = error("Stack underflow")

-- Division
eval "/" (Integer x: Integer y:tl) = Integer (y `div` x) : tl
eval "/" (x:y:tl) = (Real $ toFloat y / toFloat x) : tl
eval "/" _ = error("Stack underflow")

-- Power
eval "^" (Integer x: Integer y:tl) = Integer (y ^ x) : tl
eval "^" (x:y:tl) = (Real $ toFloat y ** toFloat x) : tl
eval "^" _ = error("Stack underflow")

-- Duplicate the element at the top of the stack
eval "DUP" (x:tl) = (x:x:tl)
eval "DUP" [] = error("Stack underflow")

-- STR: converts argument to string
eval "STR" (x:tl) = Str (valToStr x) : tl
eval "STR" [] = error("Stack underflow")

-- CONCAT2: concatenates 2 strings
eval "CONCAT2" (Str s1: Str s2:tl) = Str (s2 ++ s1) : tl
eval "CONCAT2" _ = error("Arguments must be strings")

-- CONCAT3: concatenates 3 strings
eval "CONCAT3" (Str s1: Str s2: Str s3:tl) = Str (s3 ++ s2 ++ s1) : tl
eval "CONCAT3" _ = error("Arguments must be strings")

-- this must be the last rule
-- it assumes that no match is made and preserves the string as argument
eval s l = Id s : l 


-- variant of eval with output
-- state is a stack and string pair
evalOut :: String -> ([Val], String) -> ([Val], String) 
-- print element at the top of the stack
evalOut "." (Id x:tl, out) = (tl, out ++ x)
evalOut "." (Integer i:tl, out) = (tl, out ++ (show i))
evalOut "." (Real x:tl, out) = (tl, out ++ (show x))
evalOut "." (Str s:tl, out) = (tl, out ++ s)
evalOut "." ([], _) = error "Stack underflow"

-- EMIT: prints character with ASCII code from top of stack
evalOut "EMIT" (Integer i:tl, out) = (tl, out ++ [chr i])
evalOut "EMIT" _ = error "EMIT requires an integer"

-- CR: prints a newline
evalOut "CR" (stack, out) = (stack, out ++ "\n")

-- this has to be the last case
-- if no special case, ask eval to deal with it and propagate output
evalOut op (stack, out) = (eval op stack, out)