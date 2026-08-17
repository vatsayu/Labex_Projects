# LABEX Project 01 — Linux Server Information

## 1. Project Information

**Project:** Linux Server Information
**Track:** Linux Foundations
**Implementation:** Bash
**Environment:** Kali Linux Virtual Machine
**Status:** Completed — Version 1.0

## 2. Objective

The objective of this project was to develop a Bash utility capable of collecting important Linux host information and presenting the results in a structured format.

The project was designed as the first practical exercise in the LABEX Linux Foundations track.

## 3. Information Collected

The completed tool collects:

1. Hostname
2. Operating system
3. Kernel version
4. Architecture
5. CPU information
6. CPU core count
7. Memory usage
8. Disk usage
9. Logged-in users
10. Network interfaces
11. IP addresses
12. Running systemd services

## 4. Environment

The project was tested on a Kali Linux virtual machine.

The observed environment included:

```text
Operating System : Kali GNU/Linux Rolling
Architecture     : x86_64
Kernel           : 7.0.12+kali-amd64
```

The system was running inside a virtualized environment.

## 5. Tools and Commands

The implementation uses standard Linux utilities including:

```text
hostname
uname
grep
cut
lscpu
nproc
free
df
uptime
who
ip
systemctl
```

## 6. Implementation

The script was divided into functions to keep the implementation organized.

The main components are:

```text
print_section()
show_header()
show_system()
show_hardware()
show_users()
show_network()
show_services()
```

A reusable section-printing function was introduced to reduce repeated formatting code.

Example:

```bash
print_section() {
        echo
        echo "[ $1 ]"
}
```

## 7. System Information

The system information section uses:

```bash
hostname
uname -r
uname -m
uptime -p
```

Operating system information is extracted from:

```text
/etc/os-release
```

using:

```bash
grep '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f2
```

## 8. Hardware Information

Hardware information is collected using:

```bash
lscpu
nproc
free -h
df -h /
```

The implementation reports CPU information, CPU cores, memory usage, and root filesystem usage.

## 9. User Information

Logged-in users are identified using:

```bash
who
```

The number of active login sessions is calculated using:

```bash
who | wc -l
```

During testing, one logged-in user session was detected.

## 10. Network Information

Network interfaces and their addresses are collected using:

```bash
ip -br addr
```

The test environment contained multiple interfaces, including:

```text
lo
eth0
eth1
PROTON_VPN-NL
```

The output demonstrated that the script can identify both normal network interfaces and the VPN interface present on the test system.

## 11. Running Services

The project initially used:

```bash
ps
```

for process information.

During development, this was identified as different from enumerating running services.

The implementation was therefore changed to:

```bash
systemctl list-units --type=service --state=running --no-pager
```

The final test detected 21 loaded/running service units.

Examples included:

```text
cron.service
NetworkManager.service
ssh.service
systemd-journald.service
systemd-logind.service
systemd-timesyncd.service
```

## 12. Testing

The script was executed directly from the project `scripts` directory:

```bash
./system_info.sh
```

The script successfully generated structured output containing all major information categories.

### Test Result

| Component            | Result |
| -------------------- | ------ |
| Header               | PASS   |
| System information   | PASS   |
| Hardware information | PASS   |
| User information     | PASS   |
| Network information  | PASS   |
| Running services     | PASS   |

## 13. Development Issues Identified

Several small implementation errors were encountered during development.

### Variable naming error

An IP address variable was initially defined with one spelling and referenced with another.

This demonstrated that Bash variables are case-sensitive.

### Kernel variable case mismatch

A variable defined as:

```bash
kernel
```

was initially referenced as:

```bash
Kernel
```

This produced an empty value because Bash variable names are case-sensitive.

### Incorrect process/service distinction

The initial implementation used:

```bash
ps
```

for the running services requirement.

This was corrected to use `systemctl`, which more accurately represents systemd services.

### Formatting improvements

The project introduced a reusable:

```bash
print_section()
```

function to improve consistency and reduce repeated code.

## 14. Security Relevance

Although this is primarily a Linux administration project, the information collected can also be useful during security assessments and incident response.

Examples include:

* Identifying the operating system
* Identifying kernel versions
* Understanding available network interfaces
* Identifying VPN interfaces
* Identifying logged-in users
* Identifying running services

This information can help establish an initial understanding of a Linux host during an authorized security investigation.

## 15. Result

The first LABEX project successfully produced a working Bash-based Linux system information utility.

The project demonstrated practical understanding of Linux commands, Bash scripting, functions, variables, command substitution, text processing, networking commands, and systemd service enumeration.

## 16. Future Improvements

Future versions can introduce:

* Command-line arguments
* Help functionality
* Error handling
* Dependency checks
* Timestamped report generation
* File output
* JSON output
* Automated tests
* Improved service parsing
* Python implementation

## 17. Ethical and Scope Notes

Testing was performed against the local LABEX Linux environment.

The project does not require interaction with external systems and is intended for system administration, automation, and cybersecurity learning.

## 18. Final Status

**LABEX Project 01 — COMPLETED**

Version: **1.0**

Next stage:

```text
Project 01
    ↓
Documentation
    ↓
Testing
    ↓
Git commit
    ↓
GitHub
    ↓
Project 02
```

