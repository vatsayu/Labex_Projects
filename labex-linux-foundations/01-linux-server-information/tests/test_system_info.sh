#!/bin/bash

SCRIPT="../scripts/system_info.sh"

echo "[+] Testing system_info.sh"

if [ ! -f "$SCRIPT" ]; then
	echo "[FAIL] Script not found"
	exit 1
fi

if [ ! -x "$SCRIPT" ]; then
	echo "[FAIL] Script not executable"
	exit 1
fi

output=$("$SCRIPT")

if echo "$output" | grep -q "\[ SYSTEM ]"; then
	echo "[PASS] System section found"
else
	echo "[FAIL] System section missing"
	exit 1
fi

if echo "$output" | grep -q "\[ HARDWARE \]"; then
	echo "[PASS] Hardware section found"
else
	echo "[FAIL] Hardware section missing"
	exit 1
fi

if echo "$output" | grep -q "\[ USERS \]"; then
	echo "[PASS] Users section found"
else
	echo "[FAIL] Users section missing"
	exit 1
fi

if echo "$output" | grep -q "\[ NETWORK \]"; then
	echo "[PASS] Network section found"
else
	echo "[FAIL] Network section missing"
	exit 1
fi

if echo "$output" | grep -q "\[ SERVICES \]"; then
	echo "[PASS] Services section found"
else
	echo "[FAIL] Services section missing"
	exit 1
fi

echo "[+]  All tests passed"










