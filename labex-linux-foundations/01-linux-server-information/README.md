# LABEX Project 01 — Linux Server Information

## Overview

This project is the first project in the LABEX Linux Foundations track.

The objective is to build a Bash-based Linux system information utility that collects and displays important information about the host system in a structured format.

The project was developed and tested on a Kali Linux virtual machine.

## Objectives

The tool collects:

* Hostname
* Operating system
* Kernel version
* System architecture
* CPU information
* CPU core count
* Memory usage
* Disk usage
* Logged-in users
* Network interfaces and IP addresses
* Running systemd services

## Technologies

* Linux
* Bash
* `hostname`
* `uname`
* `/etc/os-release`
* `grep`
* `cut`
* `lscpu`
* `nproc`
* `free`
* `df`
* `uptime`
* `who`
* `ip`
* `systemctl`

## Project Structure

```text
01-linux-server-information/
├── README.md
├── scripts/
│   └── system_info.sh
├── tests/
│   └── test_system_info.sh
├── output/
├── screenshots/
└── docs/
    └── lab-report.md
```

## Usage

Make the script executable:

```bash
chmod +x scripts/system_info.sh
```

Run the tool:

```bash
./scripts/system_info.sh
```

## Example Output

```text
===========================================
          LABEX SYSTEM INFORMATION
===========================================

[ SYSTEM ]
Hostname          : kali
Operating System  : Kali GNU/Linux Rolling
Kernel            : 7.0.12+kali-amd64
Architecture      : x86_64
Uptime            : up 1 hour, 33 minutes

[ HARDWARE ]
CPU               : 13th Gen Intel(R) Core(TM) i7-13620H
CPU Cores         : 4
Memory            : 927Mi used / 5.8Gi total
Disk              : 26G used / 58G total (46% used)

[ USERS ]
Logged-in Users   : 1

[ NETWORK ]
Interfaces and IP Addresses:
lo
eth0
eth1
PROTON_VPN-NL

[ SERVICES ]
Running Services:
accounts-daemon.service
cron.service
dbus.service
NetworkManager.service
ssh.service
systemd-journald.service
...
```

## Implementation Concepts

### Command Substitution

The script uses Bash command substitution:

```bash
host=$(hostname)
kernel=$(uname -r)
```

This executes a command and stores its output in a variable.

### Local Variables

Functions use local variables:

```bash
local host
local os
local kernel
```

This prevents unnecessary global variables.

### OS Detection

The operating system name is extracted from `/etc/os-release`:

```bash
grep '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f2
```

### Network Information

The script uses:

```bash
ip -br addr
```

The brief output makes network information easier to read than the full `ip addr` output.

### Service Enumeration

Running systemd services are obtained using:

```bash
systemctl list-units --type=service --state=running --no-pager
```

This is preferable to `ps` when the objective is specifically to identify running services.

## Learning Outcomes

This project introduced:

* Bash scripting
* Variables
* Functions
* Local variables
* Command substitution
* Pipes
* Text processing
* Linux system information commands
* Linux networking commands
* systemd service management
* Basic shell debugging

## Testing

The script was manually executed on the LABEX Kali Linux environment.

The implementation successfully returned:

* System information
* Hardware information
* Logged-in user information
* Network information
* Running service information

## Future Improvements

Potential future versions may add:

* Command-line arguments
* `--help`
* `--save`
* Timestamped reports
* Error handling
* Dependency checking
* Cleaner service output
* Automated tests
* JSON output
* Python implementation

## Scope and Ethics

This project is intended for Linux administration, scripting, and learning purposes.

The tool collects information from the local system on which it is executed. It does not perform unauthorized scanning or exploitation.

## LABEX

This project is part of the LABEX practical project portfolio.

The LABEX approach is:

```text
Understand
    ↓
Design
    ↓
Build
    ↓
Test
    ↓
Document
    ↓
Publish
```
