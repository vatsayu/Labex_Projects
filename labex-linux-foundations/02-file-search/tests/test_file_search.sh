#!/bin/bash

SCRIPT="../scripts/file_search.sh"

echo "[+] Testing file_search.sh"
echo

# Test 1: Script exists
if [ ! -f "$SCRIPT" ]; then
    echo "[FAIL] Script not found"
    exit 1
fi

echo "[PASS] Script exists"

# Test 2: Markdown search
output=$("$SCRIPT" ".." "*.md")

if echo "$output" | grep -q "README.md"; then
    echo "[PASS] Markdown file search"
else
    echo "[FAIL] Markdown file search"
    exit 1
fi

# Test 3: Shell script search
output=$("$SCRIPT" ".." "*.sh")

if echo "$output" | grep -q "file_search.sh"; then
    echo "[PASS] Shell script search"
else
    echo "[FAIL] Shell script search"
    exit 1
fi

# Test 4: No matching files
output=$("$SCRIPT" ".." "*.pdf")

if echo "$output" | grep -q "No matching files found."; then
    echo "[PASS] No-match handling"
else
    echo "[FAIL] No-match handling"
    exit 1
fi

# Test 5: Missing arguments
output=$("$SCRIPT" 2>&1)

if echo "$output" | grep -q "Usage:"; then
    echo "[PASS] Argument validation"
else
    echo "[FAIL] Argument validation"
    exit 1
fi

# Test 6: Invalid directory
output=$("$SCRIPT" "/does/not/exist" "*.txt" 2>&1)

if echo "$output" | grep -q "Directory does not exist"; then
    echo "[PASS] Invalid directory handling"
else
    echo "[FAIL] Invalid directory handling"
    exit 1
fi

echo
echo "[+] All tests passed"
