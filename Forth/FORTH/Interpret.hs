module Interpret where
-- this file contains the FORTH interpreter

import Val
import Eval
import Flow
import qualified Data.Map as Map

-- Dictionary type for user-defined functions
type FuncDict = Map.Map String [Val]

-- Extended state: stack, output, function dictionary
type State = ([Val], String, FuncDict)

-- Parse function definitions from token list
-- Returns (remaining tokens, function dictionary)
parseFunctions :: [Val] -> FuncDict -> ([Val], FuncDict)
parseFunctions [] dict = ([], dict)
parseFunctions (Id ":" : Id name : rest) dict = 
    let (body, remaining) = extractUntilSemicolon rest []
        newDict = Map.insert name body dict
    in parseFunctions remaining newDict
parseFunctions (x:xs) dict = 
    let (remaining, finalDict) = parseFunctions xs dict
    in (x:remaining, finalDict)

-- Extract tokens until semicolon
extractUntilSemicolon :: [Val] -> [Val] -> ([Val], [Val])
extractUntilSemicolon [] acc = (reverse acc, [])
extractUntilSemicolon (Id ";" : rest) acc = (reverse acc, rest)
extractUntilSemicolon (x:xs) acc = extractUntilSemicolon xs (x:acc)

-- Execute a user-defined function by expanding its body
executeUserFunc :: String -> FuncDict -> [Val] -> [Val]
executeUserFunc name dict tokens = 
    case Map.lookup name dict of
        Just body -> body ++ tokens
        Nothing -> Id name : tokens

-- inner function for foldl with function dictionary
-- Takes the current state and an input and computes the next state
evalF :: State -> Val -> State
evalF (stack, out, dict) (Id op) = 
    case Map.lookup op dict of
        Just body -> 
            -- Execute user-defined function by processing its body
            let (newStack, newOut, _) = foldl evalF (stack, out, dict) body
            in (newStack, newOut, dict)
        Nothing -> 
            -- Built-in operation
            let (newStack, newOut) = evalOut op (stack, out)
            in (newStack, newOut, dict)
-- cannot run, put on the stack and preserve output
evalF (s, out, dict) x = (x:s, out, dict)

-- function to interpret a string into a stack and an output string
interpret :: String -> ([Val], String)
interpret text = 
    let tokens = text |> words |> map strToVal
        (execTokens, funcDict) = parseFunctions tokens Map.empty
        (finalStack, finalOut, _) = foldl evalF ([], "", funcDict) execTokens
    in (finalStack, finalOut)
