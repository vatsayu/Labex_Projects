# Linux System Monitor Using Bash

A Bash-based system monitoring utility that collects system information, measures resource utilization, checks configurable thresholds, and reports the overall system health.

## Project Overview

This project demonstrates practical Linux administration and Bash automation skills by building a lightweight command-line monitoring tool.

The script checks CPU, memory, disk, uptime, network information, logged-in users, and running services. It also generates warnings when resource usage exceeds configured thresholds.

## Objectives

* Automate Linux system monitoring using Bash
* Collect system and resource information
* Calculate CPU and memory utilization
* Monitor root filesystem usage
* Detect resource threshold violations
* Display a clear system health status
* Return meaningful exit codes
* Validate functionality using automated tests

## Features

* Hostname and operating system detection
* Kernel and uptime information
* CPU usage calculation
* Memory usage calculation
* Root disk usage monitoring
* Logged-in user count
* IP address discovery
* Running service count
* Configurable warning thresholds
* HEALTHY/WARNING status
* Automated test suite

## Project Structure

```text
01-linux-system-monitor/
├── README.md
├── docs/
│   └── lab-report.md
├── output/
│   └── sample-system-monitor.txt
├── screenshots/
├── scripts/
│   └── system_monitor.sh
└── tests/
    └── test_system_monitor.sh
```

## Requirements

* Linux operating system
* Bash
* `top`
* `free`
* `df`
* `hostname`
* `systemctl`
* `awk`
* `grep`

## Usage

Make the script executable:

```bash
chmod +x scripts/system_monitor.sh
```

Run the monitor:

```bash
./scripts/system_monitor.sh
```

If warnings occur, the script may return a non-zero exit code.

To save output:

```bash
./scripts/system_monitor.sh > output/sample-system-monitor.txt || true
```

## Configurable Thresholds

Default thresholds are:

```text
CPU: 80%
Memory: 80%
Disk: 80%
```

Thresholds can be temporarily overridden:

```bash
CPU_THRESHOLD=0 MEMORY_THRESHOLD=0 DISK_THRESHOLD=0 \
./scripts/system_monitor.sh || true
```

This safely demonstrates warning behavior without stressing the system.

## Example Output

```text
LINUX SYSTEM MONITOR
CPU Usage       : 1.70%
Memory Usage    : 20.19%
Disk Usage /    : 6%
System Health   : HEALTHY
```

## Testing

Run the complete test suite:

```bash
./tests/test_system_monitor.sh
```

The test suite validates:

* Script existence
* Executable permission
* Bash syntax
* Header output
* CPU information
* Memory information
* Disk information
* Health status
* Timestamp
* Network information
* Uptime
* Running services
* Warning detection
* Warning status
* Non-zero warning exit code

## Security and Safety Considerations

* No credentials are collected or stored
* No system modifications are performed
* No files are deleted or changed
* Threshold testing uses environment variables
* Network information should be sanitized before public publication
* Screenshots should not expose sensitive host details

## Learning Outcomes

* Bash functions and variables
* Command substitution
* Linux monitoring commands
* Numeric comparisons using `awk`
* Exit-code handling
* Environment-variable configuration
* Automated shell testing
* Basic operational health monitoring

## Future Improvements

* Add continuous monitoring mode
* Add CSV or JSON output
* Add email or webhook alerts
* Add process-level CPU monitoring
* Add configurable command-line arguments
* Add log rotation
* Add integration with a SIEM platform

## Status

**Implementation complete — automated tests passed.**
