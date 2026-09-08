# Lab Report — Automated System Log Backup

## 1. Project Information

**Track:** Linux Foundations
**Project:** Automated System Log Backup
**Implementation:** Bash
**Environment:** Linux virtual machine
**Status:** Completed

---

## 2. Objective

The objective of this project was to develop a Bash utility capable of collecting selected log files, creating timestamped backups, compressing the collected data, verifying archive integrity, generating cryptographic checksums, and producing a human-readable backup report.

The project was implemented using controlled sample log files to avoid unnecessary modification of real system logs.

---

## 3. Scope

The final implementation provides:

* Log-file discovery
* Source-directory validation
* Missing-log detection
* Timestamped backup directories
* `tar.gz` compression
* Archive verification
* Expected-file verification
* SHA-256 manifest generation
* SHA-256 verification
* Backup reporting
* Error handling
* Automated testing

---

## 4. Project Environment

Development and testing were performed in a controlled Linux virtual-machine environment.

### Tools Used

| Tool        | Purpose                              |
| ----------- | ------------------------------------ |
| Bash        | Script implementation                |
| `find`      | Log-file discovery                   |
| `date`      | Timestamp generation                 |
| `tar`       | Archive creation                     |
| `gzip`      | Compression                          |
| `sha256sum` | Cryptographic integrity verification |
| `grep`      | Archive-content verification         |
| `du`        | Archive-size reporting               |
| `bash -n`   | Syntax checking                      |

---

## 5. Test Data

The project uses three controlled sample log files:

```text
test-data/
├── application.log
├── auth.log
└── system.log
```

The sample logs contain synthetic laboratory events.

This avoids exposing real authentication events, host information, network addresses, or other sensitive system data in the public repository.

---

## 6. Backup Workflow

The final workflow is:

```text
Start
  |
  v
Validate source directory
  |
  v
Discover .log files
  |
  v
Verify logs exist
  |
  v
Count log files
  |
  v
Create timestamped destination
  |
  v
Create compressed archive
  |
  v
Verify archive exists
  |
  v
Verify archive is non-empty
  |
  v
Verify archive can be read
  |
  v
Verify expected log files
  |
  v
Generate SHA-256 manifest
  |
  v
Verify SHA-256
  |
  v
Generate backup report
  |
  v
Complete
```

---

## 7. Log Discovery

The script stores matching log files in a Bash array:

```bash
LOG_FILES=("$SOURCE_DIR"/*.log)
```

The number of discovered files is calculated using:

```bash
LOG_COUNT=${#LOG_FILES[@]}
```

This allows the script to report how many log files are being backed up.

---

## 8. Missing-Log Handling

The script checks whether any `.log` files exist before creating an archive.

Example failure:

```text
[ERROR] No log files found in: ./empty-test-data
```

This prevents the script from creating a meaningless backup when the source directory contains no matching logs.

---

## 9. Timestamped Backups

Each backup receives a unique timestamp:

```bash
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
```

The resulting directory follows the pattern:

```text
YYYY-MM-DD_HH-MM-SS
```

Example:

```text
2026-09-08_21-10-38
```

Timestamped directories prevent successive backups from overwriting each other.

---

## 10. Compression

The selected log files are compressed using:

```bash
tar -czf "$ARCHIVE" "${LOG_FILES[@]}"
```

The options used are:

* `-c` — create archive
* `-z` — gzip compression
* `-f` — specify archive filename

The resulting artifact is:

```text
system-logs.tar.gz
```

---

## 11. Archive Integrity Verification

After creating the archive, the script verifies that it can be read:

```bash
tar -tzf "$ARCHIVE" >/dev/null 2>&1
```

A successful exit status indicates that `tar` can read the archive.

The script also verifies that the expected log files are present.

---

## 12. SHA-256 Integrity Verification

A SHA-256 manifest is generated for the archive.

Example:

```text
<64-character-hash>  system-logs.tar.gz
```

The manifest is later verified using:

```bash
sha256sum -c manifest.sha256
```

Successful verification produces:

```text
system-logs.tar.gz: OK
```

This provides a cryptographic mechanism for detecting modifications to the backup archive.

---

## 13. Tamper Detection

A copy of a backup archive was used for a controlled tamper-detection test.

The original archive successfully passed checksum verification.

After modifying the copied archive, checksum verification was expected to fail.

The intended security behavior is:

```text
Original archive
      |
      v
SHA-256 verification
      |
      v
PASS

Modified archive
      |
      v
SHA-256 verification
      |
      v
FAIL
```

This demonstrates that the checksum can detect changes to the backup data.

---

## 14. Backup Report

Each successful backup produces:

```text
backup-report.txt
```

The report records:

* Backup timestamp
* Source directory
* Number of log files
* Archive name
* Archive size
* SHA-256 hash
* Archive integrity status
* SHA-256 integrity status
* Overall backup status

Example:

```text
Backup Timestamp : 2026-09-08_21-10-38
Source Directory : ./test-data
Log Files        : 3
Archive          : system-logs.tar.gz

Archive Integrity : PASS
SHA-256 Integrity : PASS

Backup Status     : SUCCESS
```

---

## 15. Automated Testing

The test suite is located at:

```text
tests/test_log_backup.sh
```

It performs fourteen automated checks.

|  # | Test                         | Result |
| -: | ---------------------------- | ------ |
|  1 | Script exists                | PASS   |
|  2 | Bash syntax                  | PASS   |
|  3 | Test source directory        | PASS   |
|  4 | Expected log files           | PASS   |
|  5 | Backup execution             | PASS   |
|  6 | Timestamped backup directory | PASS   |
|  7 | Compressed archive           | PASS   |
|  8 | Archive non-empty            | PASS   |
|  9 | Archive integrity            | PASS   |
| 10 | Expected logs in archive     | PASS   |
| 11 | SHA-256 manifest             | PASS   |
| 12 | SHA-256 verification         | PASS   |
| 13 | Backup report                | PASS   |
| 14 | Backup report status         | PASS   |

### Final Result

```text
====================================
TEST SUMMARY
====================================
Passed : 14
Failed : 0

[+] All tests passed
```

---

## 16. Error Handling

The script checks for:

* Missing source directory
* No log files
* Archive creation failure
* Missing archive
* Empty archive
* Invalid archive
* Missing expected log files
* SHA-256 manifest failure
* SHA-256 verification failure

Failures result in a non-zero exit status.

This allows the script to be used safely by automated workflows.

---

## 17. Security Considerations

The project was designed with controlled testing and public repository safety in mind.

### Data Protection

Real system logs can contain:

* Usernames
* IP addresses
* Authentication events
* Hostnames
* Application information
* Potentially sensitive operational details

Therefore, synthetic test logs were used for development and public evidence.

### Integrity

A SHA-256 manifest is generated to detect modification of the backup archive.

### Authorization

The utility should only be used to collect logs from systems and directories for which the operator has authorization.

### Repository Hygiene

Sensitive runtime artifacts, credentials, and real system logs should not be committed to a public repository.

---

## 18. Lessons Learned

This project provided practical experience with:

1. Bash arrays and wildcard expansion.
2. File discovery using `find` and shell patterns.
3. Timestamp-based directory organization.
4. `tar` archive creation.
5. gzip compression.
6. Exit-status based error handling.
7. SHA-256 integrity verification.
8. Backup validation.
9. Automated Bash testing.
10. Security considerations for log handling.

A key lesson was that a successful archive command does not automatically prove that the resulting backup is trustworthy. Explicit integrity and content verification provide stronger assurance.

---

## 19. Future Improvements

Future versions could implement:

* Configurable source and destination paths
* Backup retention policies
* Automatic deletion of expired backups
* Cron scheduling
* Systemd timers
* Remote backup storage
* Encryption
* Digital signatures
* JSON reporting
* Centralized SIEM integration
* Log rotation integration

These features are outside the scope of the current project.

---

## 20. Final Result

The completed utility successfully:

* Discovers log files.
* Creates timestamped backups.
* Compresses logs into a `tar.gz` archive.
* Verifies archive integrity.
* Verifies expected log contents.
* Generates a SHA-256 manifest.
* Verifies the archive checksum.
* Generates a backup report.
* Handles missing-log conditions.
* Passes all automated tests.

Final automated result:

```text
14 tests passed
0 tests failed
```

**Project status: COMPLETE**
