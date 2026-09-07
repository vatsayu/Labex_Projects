#!/bin/bash

SCRIPT="./scripts/user_setup.sh"
TEST_USER="labtest"
TEST_GROUP="developers"

echo "[+] Testing user_setup.sh"
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

# Test 3: Missing arguments
if "$SCRIPT" >/dev/null 2>&1; then
    fail_test "Missing argument validation"
else
    pass_test "Missing argument validation"
fi

# Test 4: Invalid username
if sudo "$SCRIPT" "bad user" "$TEST_GROUP" >/dev/null 2>&1; then
    fail_test "Invalid username validation"
else
    pass_test "Invalid username validation"
fi

# Test 5: Invalid group
if sudo "$SCRIPT" "$TEST_USER" "bad group" >/dev/null 2>&1; then
    fail_test "Invalid group validation"
else
    pass_test "Invalid group validation"
fi

# Test 6: Create test account
if sudo "$SCRIPT" "$TEST_USER" "$TEST_GROUP" >/dev/null 2>&1; then
    pass_test "User creation"
else
    fail_test "User creation"
fi

# Test 7: Verify user exists
if id "$TEST_USER" >/dev/null 2>&1; then
    pass_test "User exists"
else
    fail_test "User exists"
fi

# Test 8: Verify primary group
PRIMARY_GROUP=$(id -gn "$TEST_USER")

if [ "$PRIMARY_GROUP" = "$TEST_GROUP" ]; then
    pass_test "Primary group assignment"
else
    fail_test "Primary group assignment"
fi

# Test 9: Verify home directory
if [ -d "/home/$TEST_USER" ]; then
    pass_test "Home directory creation"
else
    fail_test "Home directory creation"
fi

# Test 10: Verify shell
USER_SHELL=$(getent passwd "$TEST_USER" | cut -d: -f7)

if [ "$USER_SHELL" = "/bin/bash" ]; then
    pass_test "Bash shell assignment"
else
    fail_test "Bash shell assignment"
fi

# Test 11: Verify password aging
MAX_DAYS=$(sudo chage -l "$TEST_USER" | awk -F: '/Maximum number/ {gsub(/ /,"",$2); print $2}')

if [ "$MAX_DAYS" = "90" ]; then
    pass_test "Password aging configuration"
else
    fail_test "Password aging configuration"
fi

# Test 12: Duplicate user detection
if sudo "$SCRIPT" "$TEST_USER" "$TEST_GROUP" >/dev/null 2>&1; then
    fail_test "Duplicate user detection"
else
    pass_test "Duplicate user detection"
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