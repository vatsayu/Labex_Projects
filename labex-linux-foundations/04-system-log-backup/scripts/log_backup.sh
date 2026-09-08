#!/bin/bash

echo "===================================="
echo "       SYSTEM LOG BACKUP"
echo "===================================="

SOURCE_DIR="./test-data"
BACKUP_DIR="./output"

if [ ! -d "$SOURCE_DIR" ]; then
    echo "[ERROR] Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

LOG_FILES=("$SOURCE_DIR"/*.log)

if [ ! -e "${LOG_FILES[0]}" ]; then
    echo "[ERROR] No log files found in: $SOURCE_DIR"
    exit 1
fi

LOG_COUNT=${#LOG_FILES[@]}

echo
echo "[ Log Discovery ]"
echo "Log files found: $LOG_COUNT"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DEST_DIR="$BACKUP_DIR/$TIMESTAMP"

mkdir -p "$DEST_DIR"

echo
echo "[ Backup Information ]"
echo "Source      : $SOURCE_DIR"
echo "Destination : $DEST_DIR"

ARCHIVE="$DEST_DIR/system-logs.tar.gz"

tar -czf "$ARCHIVE" "${LOG_FILES[@]}"

if [ "$?" -eq 0 ]; then
    echo
    echo "Logs compressed successfully."
else
    echo
    echo "[ERROR] Failed to create compressed archive."
    exit 1
fi

echo
echo "[ Backup Archive ]"
ls -lh "$ARCHIVE"

echo
echo "[ Archive Contents ]"
tar -tzf "$ARCHIVE"

echo
echo "[ Integrity Verification ]"

if [ ! -f "$ARCHIVE" ]; then
    echo "[ERROR] Backup archive does not exist."
    exit 1
fi

if [ ! -s "$ARCHIVE" ]; then
    echo "[ERROR] Backup archive is empty."
    exit 1
fi

if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
    echo "Archive integrity check: PASS"
else
    echo "Archive integrity check: FAIL"
    exit 1
fi

for logfile in application.log auth.log system.log; do
    if tar -tzf "$ARCHIVE" | grep -q "$logfile"; then
        echo "[PASS] $logfile present"
    else
        echo "[FAIL] $logfile missing"
        exit 1
    fi
done

echo
echo "[ SHA-256 Verification ]"

MANIFEST="$DEST_DIR/manifest.sha256"

(
    cd "$DEST_DIR" || exit 1
    sha256sum "$(basename "$ARCHIVE")" > "manifest.sha256"
)

if [ "$?" -eq 0 ]; then
    echo "SHA-256 manifest created successfully."
else
    echo "[ERROR] Failed to create SHA-256 manifest."
    exit 1
fi

echo
echo "Manifest:"
cat "$MANIFEST"

echo
echo "Hash Verification:"

if (
    cd "$DEST_DIR" || exit 1
    sha256sum -c "manifest.sha256"
); then
    echo "SHA-256 verification: PASS"
else
    echo "SHA-256 verification: FAIL"
    exit 1
fi
REPORT="$DEST_DIR/backup-report.txt"

{
    echo "===================================="
    echo "       SYSTEM LOG BACKUP REPORT"
    echo "===================================="
    echo
    echo "Backup Timestamp : $TIMESTAMP"
    echo "Source Directory : $SOURCE_DIR"
    echo "Log Files        : $LOG_COUNT"
    echo "Archive          : system-logs.tar.gz"
    echo "Archive Size     : $(du -h "$ARCHIVE" | cut -f1)"
    echo
    echo "SHA-256:"
    sha256sum "$ARCHIVE" | cut -d' ' -f1
    echo
    echo "Archive Integrity : PASS"
    echo "SHA-256 Integrity : PASS"
    echo
    echo "Backup Status     : SUCCESS"
} > "$REPORT"

echo
echo "[ Backup Report ]"
cat "$REPORT"
