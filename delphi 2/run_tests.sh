#!/bin/bash

# Delphi Project Test Runner
# Runs all test cases and reports results

echo "======================================"
echo "  Delphi Project - Test Runner"
echo "======================================"
echo ""

# Set Java path
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@11"

# Build if needed
if [ ! -d "target/classes" ]; then
    echo "Building project..."
    mvn clean compile
    echo ""
fi

# Set classpath
CP="target/classes:target/generated-sources/antlr4:$HOME/.m2/repository/org/antlr/antlr4-runtime/4.11.1/antlr4-runtime-4.11.1.jar"

echo "Running tests..."
echo ""

# Test 1
echo "Test 1: Basic Class with Constructor and I/O"
echo "Input: 42"
echo "Expected: 42"
echo -n "Actual: "
echo "42" | java -cp "$CP" Main tests/test1.pas
if [ $? -eq 0 ]; then
    echo "Status: PASS"
else
    echo "Status: FAIL"
fi
echo ""

# Test 2
echo "Test 2: Encapsulation and Methods"
echo "Input: None"
echo "Expected: 1"
echo -n "Actual: "
java -cp "$CP" Main tests/test2.pas
if [ $? -eq 0 ]; then
    echo "Status: PASS"
else
    echo "Status: FAIL"
fi
echo ""

# Test 3
echo "Test 3: Inheritance (BONUS)"
echo "Input: 5"
echo "Expected: 5"
echo -n "Actual: "
echo "5" | java -cp "$CP" Main tests/test3.pas
if [ $? -eq 0 ]; then
    echo "Status: PASS"
else
    echo "Status: FAIL"
fi
echo ""

# Test 4
echo "Test 4: Interfaces (BONUS)"
echo "Input: 100"
echo "Expected: 100"
echo -n "Actual: "
echo "100" | java -cp "$CP" Main tests/test4.pas
if [ $? -eq 0 ]; then
    echo "Status: PASS"
else
    echo "Status: FAIL"
fi
echo ""

echo "======================================"
echo "  All Tests Complete!"
echo "======================================"
