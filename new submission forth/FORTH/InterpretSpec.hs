-- HSpec tests for Val.hs
-- Execute: runhaskell InterpretSpec.hs

import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Val
import Eval
import Interpret

main :: IO ()
main = hspec $ do
  describe "interpret" $ do
    context "RPN" $ do
        it "multiplies two integers" $ do
            interpret "2 3 *" `shouldBe` ([Integer 6], "")      

        -- numerical precision makes this tricky
        it "multiplies floats and integers" $ do
            interpret "2 2.2 3.4 * *" `shouldBe` ([Real 14.960001], "")

    context "Printout" $ do
        it "computes product and outputs" $ do
            interpret "2 6 * ." `shouldBe` ([], "12")

    context "User-defined functions" $ do
        it "defines and uses SQUARE function" $ do
            interpret ": SQUARE DUP * ; 5 SQUARE" `shouldBe` ([Integer 25], "")
        
        it "defines and uses DOUBLE function" $ do
            interpret ": DOUBLE 2 * ; 7 DOUBLE" `shouldBe` ([Integer 14], "")
        
        it "uses function multiple times" $ do
            interpret ": TRIPLE 3 * ; 4 TRIPLE 2 TRIPLE" `shouldBe` ([Integer 6, Integer 12], "")
        
        it "defines function with multiple operations" $ do
            interpret ": ADDTEN 10 + ; 5 ADDTEN ." `shouldBe` ([], "15")
        
        it "defines multiple functions" $ do
            interpret ": DOUBLE 2 * ; : SQUARE DUP * ; 3 DOUBLE SQUARE" `shouldBe` ([Integer 36], "")
        
        it "function calling another function" $ do
            interpret ": DOUBLE 2 * ; : QUAD DOUBLE DOUBLE ; 3 QUAD" `shouldBe` ([Integer 12], "")