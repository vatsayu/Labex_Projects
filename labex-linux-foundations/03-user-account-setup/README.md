# Project 03 — New Colleague System Account Setup

## Overview

A Bash-based Linux user provisioning utility designed to automate the creation and initial security configuration of a new user account.

The project demonstrates practical Linux administration concepts including user and group management, home-directory creation, login-shell configuration, password-aging policies, input validation, privilege checking, and automated testing.

This project was developed as part of the **LABEX Projects — Linux Foundations** track.

---

## Objectives

* Create Linux user accounts through Bash.
* Assign a primary group during account creation.
* Create a home directory automatically.
* Configure `/bin/bash` as the login shell.
* Apply password-aging controls.
* Validate usernames and group names.
* Detect duplicate accounts.
* Require administrative privileges for account-management operations.
* Verify account configuration.
* Automate functional testing.

---

## Project Structure

```text
03-user-account-setup/
├── README.md
├── docs/
│   └── lab-report.md
├── output/
│   └── sample-user-setup.txt
├── screenshots/
│   ├── user-setup-output.png
│   └── user-setup-tests.png
├── scripts/
│   └── user_setup.sh
└── tests/
    └── test_user_setup.sh
```

---

## Requirements

* Linux operating system
* Bash
* `useradd`
* `groupadd`
* `usermod`
* `chage`
* `id`
* `getent`
* `sudo`

The project should be executed inside a controlled lab environment or disposable virtual machine.

---

## Usage

The script requires a username and primary group:

```bash
sudo ./scripts/user_setup.sh <username> <primary-group>
```

Example:

```bash
sudo ./scripts/user_setup.sh labuser developers
```

The script:

1. Validates the supplied arguments.
2. Validates the username and group format.
3. Checks administrative privileges.
4. Checks whether the user already exists.
5. Creates the group if required.
6. Creates the user with a home directory.
7. Assigns the specified primary group.
8. Configures `/bin/bash`.
9. Applies password-aging settings.
10. Verifies the resulting account.

---

## Security Configuration

The provisioning utility applies the following password-aging policy:

| Setting                  |          Value |
| ------------------------ | -------------: |
| Minimum password age     |          1 day |
| Maximum password age     |        90 days |
| Password expiry warning  |        14 days |
| Password inactive period |        30 days |
| Account expiration       | Not configured |

Passwords are **not stored or hard-coded** in the script.

---

## Testing

The project includes an automated test suite:

```bash
./tests/test_user_setup.sh
```

The test suite verifies:

* Script existence
* Bash syntax
* Argument validation
* Username validation
* Group validation
* User creation
* User existence
* Primary group assignment
* Home directory creation
* Bash shell assignment
* Password-aging configuration
* Duplicate-user detection

### Test Result

```text
Passed : 12
Failed : 0

[+] All tests passed
```

---

## Security Considerations

This project modifies Linux account configuration and should therefore only be executed on systems where the operator has authorization.

Recommended practices:

* Use a disposable virtual machine for testing.
* Never use the script against an unintended production account.
* Never hard-code passwords.
* Do not commit `/etc/passwd`, `/etc/shadow`, or sensitive system information.
* Do not publish real usernames, IP addresses, VPN details, or other environment-specific information.
* Review account permissions after provisioning.

---

## Learning Outcomes

This project provided practical experience with:

* Linux user administration
* Linux group management
* File ownership and permissions
* Bash argument handling
* Bash regular expressions
* Exit codes
* Conditional execution
* Password-aging configuration
* Privilege management
* Automated Bash testing
* Safe system administration practices

---

## Future Improvements

Potential extensions include:

* Interactive account provisioning
* Configurable password-aging policies
* Optional supplementary groups
* Account expiration support
* Logging to a dedicated audit file
* Dry-run mode
* Improved rollback/error recovery
* Configuration-file support

---

## Project Status

**Completed**

Implementation, validation, security configuration, and automated testing have been completed successfully.

Test result: **12/12 passed**.
