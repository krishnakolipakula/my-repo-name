#!/bin/bash
echo "Testing LLVM Compiler..."

CP="target/classes:target/generated-sources/antlr4:$(mvn -q dependency:build-classpath -Dmdep.outputFile=/dev/stdout 2>/dev/null)"

# Test 1: Simple arithmetic
java -cp "$CP" Compiler tests/test_llvm_simple.pas test_output_simple.ll 2>&1
echo ""
echo "=== Generated LLVM IR (test_output_simple.ll) ===" 
if [ -f test_output_simple.ll ]; then
  head -20 test_output_simple.ll
else
  echo "File not generated"
fi
