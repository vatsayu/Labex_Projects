# Lab Report: Linux System Monitor Using Bash

## 1. Objective

To develop a Bash-based Linux monitoring utility capable of collecting system information, measuring resource utilization, detecting threshold violations, and displaying an overall system health status.

## 2. Environment

* Operating System: Kali GNU/Linux Rolling
* Shell: Bash
* Platform: Linux
* Project Type: Bash Automation
* Execution Mode: Command-line utility

## 3. Tools and Commands Used

* `hostname`
* `uname`
* `/etc/os-release`
* `uptime`
* `top`
* `free`
* `df`
* `who`
* `hostname -I`
* `systemctl`
* `awk`
* `grep`

## 4. Implemented Functionality

The script was divided into reusable functions:

* `print_header`
* `get_system_information`
* `get_resource_usage`
* `get_network_information`
* `get_service_information`
* `display_information`
* `check_cpu`
* `check_memory`
* `check_disk`
* `display_health_status`
* `main`

This structure improves readability, maintainability, and troubleshooting.

## 5. Monitoring Metrics

The script collects:

* Timestamp
* Hostname
* Operating system
* Kernel version
* System uptime
* CPU utilization
* Memory utilization
* Root filesystem usage
* Logged-in user count
* IP addresses
* Running service count

## 6. Threshold Logic

The default thresholds are:

| Resource | Threshold |
| -------- | --------: |
| CPU      |       80% |
| Memory   |       80% |
| Disk     |       80% |

If a metric reaches or exceeds its threshold, the script displays a warning and increments the warning counter.

## 7. Health Status

The script reports:

* `HEALTHY` when no threshold is exceeded
* `WARNING` when one or more thresholds are exceeded

The script returns the number of warnings as its exit code.

## 8. Testing Procedure

Syntax validation:

```bash
bash -n scripts/system_monitor.sh
```

Normal execution:

```bash
./scripts/system_monitor.sh
```

Automated tests:

```bash
./tests/test_system_monitor.sh
```

Controlled warning-mode test:

```bash
CPU_THRESHOLD=0 MEMORY_THRESHOLD=0 DISK_THRESHOLD=0 \
./scripts/system_monitor.sh || true
```

## 9. Test Results

All automated tests passed.

The test suite verified:

* File existence
* Executable permissions
* Syntax validity
* Required output sections
* Resource metrics
* Health status
* Warning detection
* Warning exit behavior

## 10. Observed Normal Output

Example sanitized observations:

```text
CPU Usage       : 1.70%
Memory Usage    : 20.19%
Disk Usage /    : 6%
Running Services: 24
System Health   : HEALTHY
```

Actual hostnames, usernames, and network identifiers should be sanitized before publishing evidence.

## 11. Security Considerations

* The tool is read-only
* It does not modify system configuration
* It does not collect credentials
* It does not transmit monitoring data externally
* Public screenshots must hide sensitive network information
* Environment-variable thresholds prevent unsafe resource-stress testing

## 12. Limitations

* CPU usage depends on the output format of `top`
* Service count may vary across distributions
* The script currently monitors only the root filesystem
* It is designed for one-time execution rather than continuous monitoring
* No external alerting mechanism is included

## 13. Future Enhancements

* Continuous monitoring loop
* JSON output support
* Config file support
* Alerting through email or webhooks
* Per-process monitoring
* Historical data collection
* Integration with SIEM or observability platforms

## 14. Conclusion

The project successfully demonstrates how Bash can automate basic Linux system health monitoring. It combines Linux command-line utilities, reusable functions, configurable thresholds, warning logic, and automated validation into a practical operations-focused tool.

**Final Result: Implementation completed and all tests passed.**
