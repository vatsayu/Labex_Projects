# Project 04 — Automated System Log Backup

## Overview

A Bash-based system log backup utility that collects selected log files, creates timestamped backup directories, compresses the logs into a `tar.gz` archive, verifies archive integrity, generates a SHA-256 checksum manifest, and produces a human-readable backup report.

The project was developed as part of the **LABEX Projects — Linux Foundations** track.

The implementation was developed and tested using controlled sample log files rather than modifying or deleting real system logs.

---

## Objectives

* Automate collection of system log files.
* Detect available `.log` files.
* Create timestamped backup directories.
* Compress logs using `tar` and gzip.
* Verify that the backup archive is valid.
* Verify that expected log files are present.
* Generate a SHA-256 integrity manifest.
* Verify the archive against the SHA-256 manifest.
* Generate a backup status report.
* Handle missing log files safely.
* Automate functional testing.

---

## Project Structure

```text
04-system-log-backup/
├── README.md
├── docs/
│   └── lab-report.md
├── output/
│   └── sample-backup-report.txt
├── screenshots/
│   ├── log-backup-output.png
│   └── log-backup-tests.png
├── scripts/
│   └── log_backup.sh
├── test-data/
│   ├── application.log
│   ├── auth.log
│   └── system.log
└── tests/
    └── test_log_backup.sh
```

Generated backup archives are intentionally excluded from the documented project structure because they are runtime artifacts.

---

## Requirements

* Linux
* Bash
* `tar`
* `gzip`
* `sha256sum`
* `grep`
* `find`
* `du`
* `date`

---

## Usage

From the project root:

```bash
./scripts/log_backup.sh
```

The script currently uses:

```text
./test-data
```

as its controlled source directory.

Backups are created under:

```text
./output/
```

---

## Backup Workflow

```text
Log Discovery
      |
      v
Validate Source
      |
      v
Find .log Files
      |
      v
Create Timestamp
      |
      v
Create tar.gz Archive
      |
      v
Verify Archive
      |
      v
Verify Expected Logs
      |
      v
Generate SHA-256 Manifest
      |
      v
Verify SHA-256
      |
      v
Generate Backup Report
```

---

## Backup Artifacts

Each successful backup contains:

```text
<timestamp>/
├── system-logs.tar.gz
├── manifest.sha256
└── backup-report.txt
```

### `system-logs.tar.gz`

Compressed archive containing the selected log files.

### `manifest.sha256`

Contains the SHA-256 hash of the backup archive.

Example format:

```text
<sha256-hash>  system-logs.tar.gz
```

### `backup-report.txt`

Provides a human-readable summary of the backup operation.

---

## Integrity Verification

The project performs two levels of verification.

### Archive Integrity

The archive is tested using:

```bash
tar -tzf system-logs.tar.gz
```

A successful result confirms that the archive can be read.

### SHA-256 Verification

The archive hash is generated with:

```bash
sha256sum system-logs.tar.gz
```

The resulting manifest is verified using:

```bash
sha256sum -c manifest.sha256
```

Expected successful result:

```text
system-logs.tar.gz: OK
```

The project also includes a tamper-detection test in which a copy of an archive is modified and checksum verification is expected to fail.

---

## Failure Handling

The script safely handles conditions such as:

* Missing source directory
* No `.log` files
* Archive creation failure
* Missing archive
* Empty archive
* Invalid archive
* Missing expected log file
* Failed SHA-256 verification

Example:

```text
[ERROR] No log files found in: ./empty-test-data
```

---

## Automated Testing

The project includes:

```bash
./tests/test_log_backup.sh
```

The test suite verifies:

* Script existence
* Bash syntax
* Test source directory
* Expected log files
* Backup execution
* Timestamped backup creation
* Archive creation
* Archive size
* Archive integrity
* Expected log presence
* SHA-256 manifest
* SHA-256 verification
* Backup report
* Successful backup status

### Final Automated Test Result

```text
====================================
TEST SUMMARY
====================================
Passed : 14
Failed : 0

[+] All tests passed
```

---

## Security Considerations

This project performs file collection and backup operations and should only be used on systems and data where the operator has authorization.

Security practices followed:

* Development was performed using controlled test data.
* Real system logs were not required for development.
* No credentials were stored in the project.
* Backup archives were not treated as trusted without integrity verification.
* SHA-256 was used to detect accidental or unauthorized modification.
* Runtime artifacts should be reviewed before committing them to a public repository.
* Real usernames, IP addresses, hostnames, VPN information, and sensitive log contents should not be published.

---

## Learning Outcomes

This project provided practical experience with:

* Bash scripting
* File discovery
* Bash arrays
* Timestamp generation
* Archive creation
* gzip compression
* Exit codes
* Error handling
* SHA-256 checksums
* Backup integrity verification
* Linux log management concepts
* Automated Bash testing
* Security-oriented backup practices

---

## Future Improvements

Potential future enhancements include:

* Configurable source directories
* Configurable backup destinations
* Log rotation
* Retention policies
* Automatic deletion of old backups
* Systemd timer integration
* Cron integration
* Backup encryption
* Remote backup storage
* Structured JSON reports
* Centralized logging integration

---

## Project Status

**Completed**

The utility successfully performs controlled log discovery, compression, archive verification, SHA-256 integrity verification, reporting, and automated testing.

Automated test result:

**14/14 passed.**
