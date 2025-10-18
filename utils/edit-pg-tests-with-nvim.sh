#!/bin/sh

set -eu

# InfiniBand (IB) is a computer networking communications standard used in
# high-performance computing that features very high throughput and very low
# latency.

INPUT_FILES=
OUTPUT_FILES=
RESULT_FILES=

test "$#" -ne 1 && echo "USAGE: $0 <test name>" >&2 && exit 1

T="$1"

test -d 'input/' && INPUT_FILES=$(find 'input' -name "*$T*.source")
test -z "$INPUT_FILES" && test -d 'sql/' && INPUT_FILES=$(find 'sql/' -name "*$T*.sql")
test -z "$INPUT_FILES" && echo "ERROR: no tests found (input dirs)." >&2 && exit 1

test -d 'output/' && OUTPUT_FILES=$(find 'output' -name "*$T*.source")
test -z "$OUTPUT_FILES" && test -d 'expected/' && OUTPUT_FILES=$(find 'expected/' -name "*$T*.out")
test -z "$OUTPUT_FILES" && echo "ERROR: no tests found (output dirs)." >&2 && exit 1

RESULT_FILES=$(find 'results/' -name "*$T*.out")

I=$(echo "$INPUT_FILES" | head -1)
O=$(echo "$OUTPUT_FILES" | head -1)
R=$(echo "$RESULT_FILES" | head -1)

nvim -p "$I" "$O" "$R"
