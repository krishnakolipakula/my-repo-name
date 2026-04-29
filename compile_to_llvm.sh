#!/bin/bash
# Compile Delphi/Pascal to LLVM IR

if [ $# -lt 1 ]; then
    echo "Usage: $0 <input.pas> [output.ll]"
    exit 1
fi

INPUT="$1"
OUTPUT="${2:-output.ll}"

cd "$(dirname "$0")/delphi"

# Ensure it's compiled
mvn -q clean compile 2>&1 | grep -i error && exit 1

# Run compiler
java -cp "target/classes:target/generated-sources/antlr4:$(mvn -q dependency:build-classpath -Dmdep.outputFile=/dev/stdout 2>/dev/null)" \
    Compiler "$INPUT" "$OUTPUT" 2>&1

if [ -f "$OUTPUT" ]; then
    echo "✓ Generated: $OUTPUT"
    wc -l "$OUTPUT"
else
    echo "✗ Failed to generate $OUTPUT"
    exit 1
fi
