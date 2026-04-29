-- HSpec tests for Val.hs
-- Execute: runhaskell EvalSpec.hs

import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Val
import Eval

main :: IO ()
main = hspec $ do
  describe "eval" $ do
    context "*" $ do
        it "multiplies integers" $ do
            eval "*" [Integer 2, Integer 3] `shouldBe` [Integer 6]
        
        it "multiplies floats" $ do
            eval "*" [Integer 2, Real 3.0] `shouldBe` [Real 6.0]
            eval "*" [Real 3.0, Integer 3] `shouldBe` [Real 9.0]
            eval "*" [Real 4.0, Real 3.0] `shouldBe` [Real 12.0]

        it "errors on too few arguments" $ do   
            evaluate (eval "*" []) `shouldThrow` errorCall "Stack underflow"
            evaluate (eval "*" [Integer 2]) `shouldThrow` errorCall "Stack underflow"

    context "+" $ do
        it "adds integers" $ do
            eval "+" [Integer 2, Integer 3] `shouldBe` [Integer 5]
        
        it "adds floats" $ do
            eval "+" [Integer 2, Real 3.0] `shouldBe` [Real 5.0]
            eval "+" [Real 3.0, Integer 3] `shouldBe` [Real 6.0]

        it "errors on too few arguments" $ do   
            evaluate (eval "+" []) `shouldThrow` errorCall "Stack underflow"

    context "-" $ do
        it "subtracts integers" $ do
            eval "-" [Integer 2, Integer 5] `shouldBe` [Integer 3]
        
        it "subtracts floats" $ do
            eval "-" [Integer 2, Real 5.0] `shouldBe` [Real 3.0]

        it "errors on too few arguments" $ do   
            evaluate (eval "-" []) `shouldThrow` errorCall "Stack underflow"

    context "/" $ do
        it "divides integers" $ do
            eval "/" [Integer 2, Integer 6] `shouldBe` [Integer 3]
        
        it "divides floats" $ do
            eval "/" [Integer 2, Real 6.0] `shouldBe` [Real 3.0]

        it "errors on too few arguments" $ do   
            evaluate (eval "/" []) `shouldThrow` errorCall "Stack underflow"

    context "^" $ do
        it "powers integers" $ do
            eval "^" [Integer 2, Integer 3] `shouldBe` [Integer 9]
            eval "^" [Integer 3, Integer 2] `shouldBe` [Integer 8]
        
        it "powers floats" $ do
            eval "^" [Integer 2, Real 3.0] `shouldBe` [Real 9.0]

        it "errors on too few arguments" $ do   
            evaluate (eval "^" []) `shouldThrow` errorCall "Stack underflow"

    context "DUP" $ do
        it "duplicates values" $ do
            eval "DUP" [Integer 2] `shouldBe` [Integer 2, Integer 2]
            eval "DUP" [Real 2.2] `shouldBe` [Real 2.2, Real 2.2]
            eval "DUP" [Id "x"] `shouldBe` [Id "x", Id "x"]

        it "errors on empty stack" $ do
            evaluate (eval "DUP" []) `shouldThrow` errorCall "Stack underflow"

    context "STR" $ do
        it "converts integers to string" $ do
            eval "STR" [Integer 42] `shouldBe` [Str "42"]
        
        it "converts floats to string" $ do
            eval "STR" [Real 3.14] `shouldBe` [Str "3.14"]
        
        it "converts ids to string" $ do
            eval "STR" [Id "hello"] `shouldBe` [Str "hello"]

        it "errors on empty stack" $ do
            evaluate (eval "STR" []) `shouldThrow` errorCall "Stack underflow"

    context "CONCAT2" $ do
        it "concatenates two strings" $ do
            eval "CONCAT2" [Str "world", Str "hello"] `shouldBe` [Str "helloworld"]
        
        it "errors on non-strings" $ do
            evaluate (eval "CONCAT2" [Integer 1, Str "hello"]) `shouldThrow` errorCall "Arguments must be strings"

    context "CONCAT3" $ do
        it "concatenates three strings" $ do
            eval "CONCAT3" [Str "!", Str "world", Str "hello"] `shouldBe` [Str "helloworld!"]
        
        it "errors on non-strings" $ do
            evaluate (eval "CONCAT3" [Integer 1, Str "a", Str "b"]) `shouldThrow` errorCall "Arguments must be strings"

  describe "evalOut" $ do
      context "." $ do
        it "prints top of stack" $ do
            evalOut "." ([Id "x"], "") `shouldBe` ([],"x")
            evalOut "." ([Integer 2], "") `shouldBe` ([], "2")
            evalOut "." ([Real 2.2], "") `shouldBe` ([], "2.2")
            evalOut "." ([Str "hello"], "") `shouldBe` ([], "hello")

        it "errors on empty stack" $ do
            evaluate(evalOut "." ([], "")) `shouldThrow` errorCall "Stack underflow"

      context "EMIT" $ do
        it "prints ASCII character" $ do
            evalOut "EMIT" ([Integer 65], "") `shouldBe` ([], "A")
            evalOut "EMIT" ([Integer 72], "") `shouldBe` ([], "H")

        it "errors on non-integer" $ do
            evaluate(evalOut "EMIT" ([Real 65.0], "")) `shouldThrow` errorCall "EMIT requires an integer"

      context "CR" $ do
        it "prints newline" $ do
            evalOut "CR" ([Integer 1], "test") `shouldBe` ([Integer 1], "test\n")
            evalOut "CR" ([], "") `shouldBe` ([], "\n")

      it "eval pass-through" $ do
         evalOut "*" ([Real 2.0, Integer 2], "blah") `shouldBe` ([Real 4.0], "blah") 