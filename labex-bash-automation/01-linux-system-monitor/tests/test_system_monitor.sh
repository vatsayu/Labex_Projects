#!/usr/bin/env bash

set -u

# ==========================================
# Linux System Monitor Test Suite
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SCRIPT="$PROJECT_DIR/scripts/system_monitor.sh"

OUTPUT_FILE=$(mktemp)

PASSED=0
FAILED=0

pass_test() {
    echo "[PASS] $1"
    PASSED=$((PASSED + 1))
}

fail_test() {
    echo "[FAIL] $1"
    FAILED=$((FAILED + 1))
}

echo "[+] Testing system_monitor.sh"
echo

# Test 1: Script exists
if [ -f "$SCRIPT" ]; then
    pass_test "Script exists"
else
    fail_test "Script exists"
fi

# Test 2: Script is executable
if [ -x "$SCRIPT" ]; then
    pass_test "Script is executable"
else
    fail_test "Script is executable"
fi

# Test 3: Bash syntax
if bash -n "$SCRIPT"; then
    pass_test "Bash syntax check"
else
    fail_test "Bash syntax check"
fi

# Execute script and capture output
if "$SCRIPT" > "$OUTPUT_FILE" 2>&1; then
    SCRIPT_EXIT_CODE=0
else
    SCRIPT_EXIT_CODE=$?
fi

# Test 4: Header output
if grep -q "LINUX SYSTEM MONITOR" "$OUTPUT_FILE"; then
    pass_test "Monitor header displayed"
else
    fail_test "Monitor header displayed"
fi

# Test 5: CPU information
if grep -q "CPU Usage" "$OUTPUT_FILE"; then
    pass_test "CPU usage displayed"
else
    fail_test "CPU usage displayed"
fi

# Test 6: Memory information
if grep -q "Memory Usage" "$OUTPUT_FILE"; then
    pass_test "Memory usage displayed"
else
    fail_test "Memory usage displayed"
fi

# Test 7: Disk information
if grep -q "Disk Usage" "$OUTPUT_FILE"; then
    pass_test "Disk usage displayed"
else
    fail_test "Disk usage displayed"
fi

# Test 8: System health status
if grep -Eq "System Health.*(HEALTHY|WARNING)" "$OUTPUT_FILE"; then
    pass_test "System health status displayed"
else
    fail_test "System health status displayed"
fi

# Test 9: Timestamp
if grep -q "Timestamp" "$OUTPUT_FILE"; then
    pass_test "Timestamp displayed"
else
    fail_test "Timestamp displayed"
fi

# Test 10: Network information
if grep -q "IP Addresses" "$OUTPUT_FILE"; then
    pass_test "Network information displayed"
else
    fail_test "Network information displayed"
fi

# Test 11: Uptime information
if grep -q "Uptime" "$OUTPUT_FILE"; then
    pass_test "Uptime displayed"
else
    fail_test "Uptime displayed"
fi

# Test 12: Running services information
if grep -q "Running Services" "$OUTPUT_FILE"; then
    pass_test "Running services displayed"
else
    fail_test "Running services displayed"
fi

rm -f "$OUTPUT_FILE"

echo
echo "=========================================="
echo "TEST SUMMARY"
echo "=========================================="
echo "Passed : $PASSED"
echo "Failed : $FAILED"

if [ "$FAILED" -eq 0 ]; then
    echo "[+] All tests passed"
    exit 0
else
    echo "[-] Some tests failed"
    exit 1
fi
