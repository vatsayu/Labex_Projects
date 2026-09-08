#!/bin/bash

SCRIPT="./scripts/log_backup.sh"
TEST_SOURCE="./test-data"
OUTPUT_DIR="./output"

echo "[+] Testing log_backup.sh"
echo

PASS=0
FAIL=0

pass_test() {
    echo "[PASS] $1"
    PASS=$((PASS + 1))
}

fail_test() {
    echo "[FAIL] $1"
    FAIL=$((FAIL + 1))
}

# Test 1: Script exists
if [ -f "$SCRIPT" ]; then
    pass_test "Script exists"
else
    fail_test "Script exists"
fi

# Test 2: Bash syntax
if bash -n "$SCRIPT"; then
    pass_test "Bash syntax check"
else
    fail_test "Bash syntax check"
fi

# Test 3: Source directory exists
if [ -d "$TEST_SOURCE" ]; then
    pass_test "Test source directory exists"
else
    fail_test "Test source directory exists"
fi

# Test 4: Expected log files exist
LOG_COUNT=$(find "$TEST_SOURCE" -maxdepth 1 -type f -name "*.log" | wc -l)

if [ "$LOG_COUNT" -eq 3 ]; then
    pass_test "Expected log files available"
else
    fail_test "Expected log files available"
fi

# Test 5: Run backup
if "$SCRIPT" >/dev/null 2>&1; then
    pass_test "Backup execution"
else
    fail_test "Backup execution"
fi

# Find newest backup directory
LATEST_BACKUP=$(find "$OUTPUT_DIR" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)

# Test 6: Backup directory created
if [ -n "$LATEST_BACKUP" ] && [ -d "$LATEST_BACKUP" ]; then
    pass_test "Timestamped backup directory created"
else
    fail_test "Timestamped backup directory created"
fi

ARCHIVE="$LATEST_BACKUP/system-logs.tar.gz"
MANIFEST="$LATEST_BACKUP/manifest.sha256"
REPORT="$LATEST_BACKUP/backup-report.txt"

# Test 7: Archive exists
if [ -f "$ARCHIVE" ]; then
    pass_test "Compressed archive created"
else
    fail_test "Compressed archive created"
fi

# Test 8: Archive is not empty
if [ -s "$ARCHIVE" ]; then
    pass_test "Archive is not empty"
else
    fail_test "Archive is not empty"
fi

# Test 9: Archive integrity
if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
    pass_test "Archive integrity"
else
    fail_test "Archive integrity"
fi

# Test 10: Expected logs are inside archive
ARCHIVE_LOG_COUNT=$(tar -tzf "$ARCHIVE" | grep -cE '\.log$')

if [ "$ARCHIVE_LOG_COUNT" -eq 3 ]; then
    pass_test "All expected logs present in archive"
else
    fail_test "All expected logs present in archive"
fi

# Test 11: SHA-256 manifest exists
if [ -f "$MANIFEST" ]; then
    pass_test "SHA-256 manifest created"
else
    fail_test "SHA-256 manifest created"
fi

# Test 12: SHA-256 verification
if (
    cd "$LATEST_BACKUP" || exit 1
    sha256sum -c manifest.sha256 >/dev/null 2>&1
); then
    pass_test "SHA-256 verification"
else
    fail_test "SHA-256 verification"
fi

# Test 13: Backup report exists
if [ -f "$REPORT" ]; then
    pass_test "Backup report created"
else
    fail_test "Backup report created"
fi

# Test 14: Backup report indicates success
if grep -q "Backup Status     : SUCCESS" "$REPORT"; then
    pass_test "Backup report status"
else
    fail_test "Backup report status"
fi

echo
echo "===================================="
echo "TEST SUMMARY"
echo "===================================="
echo "Passed : $PASS"
echo "Failed : $FAIL"

if [ "$FAIL" -eq 0 ]; then
    echo
    echo "[+] All tests passed"
    exit 0
else
    echo
    echo "[-] Some tests failed"
    exit 1
fi