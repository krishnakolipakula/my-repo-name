#!/bin/bash
# Delphi to LLVM Compiler Wrapper

JAR="/Users/kkc/Downloads/PLP/delphi/target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar"
OUTPUT_DIR="/Users/kkc/Downloads/PLP/project3/llvm_output"

if [ ! -f "$JAR" ]; then
    echo "Building JAR..."
    cd /Users/kkc/Downloads/PLP/delphi
    mvn -q clean package -DskipTests
fi

if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) <input.pas> [output_name]"
    exit 1
fi

INPUT="$1"
NAME="${2:-$(basename "$INPUT" .pas)}"
OUTPUT="$OUTPUT_DIR/${NAME}.ll"

if [ ! -f "$INPUT" ]; then
    echo "Error: Input file not found: $INPUT"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Compiling: $INPUT -> $OUTPUT"
java -cp "$JAR" Compiler "$INPUT" "$OUTPUT" 2>&1

if [ -f "$OUTPUT" ]; then
    echo "✓ Generated: $OUTPUT"
    echo "✓ Lines: $(wc -l < "$OUTPUT")"
    echo ""
    echo "=== First 20 lines ===" 
    head -20 "$OUTPUT"
else
    echo "✗ Failed to generate output"
    exit 1
fi
