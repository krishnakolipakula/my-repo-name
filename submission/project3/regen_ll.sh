#!/usr/bin/env bash
# regen_ll.sh - regenerate LLVM IR for all tests using the packaged jar or mvn exec fallback
set -euo pipefail
ROOT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT_DIR"

echo "Packaging project (mvn clean package) ..."
mvn -q -DskipTests package

JAR=target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar
OUT_DIR=llvm_output
mkdir -p "$OUT_DIR"

if command -v java >/dev/null 2>&1 && [ -f "$JAR" ]; then
  echo "Using jar: $JAR"
  java -cp "$JAR" Compiler tests/test_simple.pas "$OUT_DIR/generated_simple.ll"
  java -cp "$JAR" Compiler tests/test_loops.pas "$OUT_DIR/generated_loops.ll"
  java -cp "$JAR" Compiler tests/test_arithmetic.pas "$OUT_DIR/generated_arithmetic.ll"
  java -cp "$JAR" Compiler tests/test_routines.pas "$OUT_DIR/generated_routines.ll"
  echo "Generated .ll files in $OUT_DIR"
  exit 0
fi

echo "java not found or jar missing; attempting mvn exec:java fallback"
MVNCMD="mvn -q exec:java -Dexec.mainClass=Compiler -Dexec.args"
"$MVNCMD" "\"tests/test_simple.pas $OUT_DIR/generated_simple.ll\""
"$MVNCMD" "\"tests/test_loops.pas $OUT_DIR/generated_loops.ll\""
"$MVNCMD" "\"tests/test_arithmetic.pas $OUT_DIR/generated_arithmetic.ll\""
"$MVNCMD" "\"tests/test_routines.pas $OUT_DIR/generated_routines.ll\""

echo "If the mvn exec fallback fails with ClassNotFoundException, run the jar locally on a machine with Java available."
