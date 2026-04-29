module Val where
-- this file contains definitions for Val and aux functions

import Data.Maybe (isJust)
import Text.Read (readMaybe)
import Data.Char (chr)

-- The values manipulated by FORTH
data Val = Integer Int 
    | Real Float
    | Id String
    | Str String
    deriving (Show, Eq)

-- converts string to Val 
-- sequence tried is Integer, Float, String
strToVal :: String -> Val
strToVal s = case readMaybe s :: Maybe Int of
    Just i -> Integer i
    Nothing -> case readMaybe s :: Maybe Float of
        Just f -> Real f 
        Nothing -> Id s

-- converts to Float if Real or Integer, error otherwise
-- used to deal with arguments of operators
toFloat :: Val -> Float
toFloat (Real x) = x
toFloat (Integer i) = fromIntegral i     
toFloat (Id _) = error "Not convertible to float"
toFloat (Str _) = error "Not convertible to float"

-- converts to Int if Integer, error otherwise
toInt :: Val -> Int
toInt (Integer i) = i
toInt (Real _) = error "Not convertible to int"
toInt (Id _) = error "Not convertible to int"
toInt (Str _) = error "Not convertible to int"

-- converts Val to String representation
valToStr :: Val -> String
valToStr (Integer i) = show i
valToStr (Real f) = show f
valToStr (Id s) = s
valToStr (Str s) = s

-- extracts string from Str Val, error otherwise
toString :: Val -> String
toString (Str s) = s
toString _ = error "Not a string"

