# Lab Report — New Colleague System Account Setup

## 1. Project Information

**Track:** Linux Foundations
**Project:** New Colleague System Account Setup
**Implementation:** Bash
**Environment:** Linux virtual machine
**Status:** Completed

---

## 2. Objective

The objective of this project was to develop a Bash utility capable of provisioning a new Linux user account while applying basic account-security controls and performing post-creation verification.

The project was designed to simulate a controlled administrative workflow for onboarding a new colleague to a Linux system.

---

## 3. Scope

The utility performs the following operations:

* User input validation
* Group validation
* Administrative privilege verification
* Duplicate-user detection
* Group creation when required
* User creation
* Home-directory creation
* Primary-group assignment
* Bash login-shell configuration
* Password-aging configuration
* Account verification

Testing was performed using disposable laboratory accounts.

---

## 4. Environment

The project was developed and tested inside a controlled Linux virtual-machine environment.

### Required Components

* Bash
* Linux account-management utilities
* `sudo`
* `useradd`
* `groupadd`
* `chage`
* `id`
* `getent`

No production systems were involved.

---

## 5. Account Provisioning Workflow

The final workflow is:

```text
User Input
    |
    v
Argument Validation
    |
    v
Username / Group Validation
    |
    v
Privilege Check
    |
    v
Duplicate User Check
    |
    v
Group Check / Creation
    |
    v
User Creation
    |
    v
Password Aging Configuration
    |
    v
Account Verification
```

---

## 6. Linux Concepts Used

### 6.1 User Creation

The `useradd` utility was used to create a new Linux account.

The relevant options were:

```bash
useradd -m -g <group> -s /bin/bash <username>
```

Where:

* `-m` creates the user's home directory.
* `-g` specifies the primary group.
* `-s` specifies the login shell.

---

### 6.2 Group Management

The project uses `groupadd` to create a group when the requested group does not already exist.

The `getent` command is used to determine whether the group already exists.

Example:

```bash
getent group developers
```

---

### 6.3 Account Verification

The `id` command verifies the resulting UID, GID, and group membership.

Example:

```bash
id labuser
```

The `getent passwd` command is used to inspect the account database entry:

```bash
getent passwd labuser
```

---

### 6.4 Password Aging

The `chage` utility was used to apply password-aging controls.

The project configured:

```bash
chage -m 1 -M 90 -W 14 -I 30 <username>
```

This configures:

* Minimum password age: 1 day
* Maximum password age: 90 days
* Expiration warning: 14 days
* Password inactivity period: 30 days

The configuration can be inspected with:

```bash
chage -l <username>
```

---

## 7. Input Validation

The utility validates that exactly two arguments are supplied:

```text
<username> <primary-group>
```

It also uses Bash regular expressions to reject invalid usernames and group names.

The validation prevents malformed input from reaching account-management commands.

---

## 8. Privilege Management

Creating and modifying Linux accounts requires administrative privileges.

The script therefore checks whether it is being executed with administrative privileges.

Running the utility without the required privileges results in a controlled error instead of attempting account-management operations.

Example:

```text
[ERROR] This script must be run with sudo or as root.
```

---

## 9. Error Handling

The utility checks for several failure conditions:

* Incorrect number of arguments
* Invalid username
* Invalid group name
* Existing username
* Failure to create a group
* Failure to create a user
* Failure to configure password aging

The script exits with a non-zero status when an operation fails.

This makes the utility easier to integrate with automated testing or larger administration workflows.

---

## 10. Testing Methodology

An automated Bash test suite was developed to verify the final implementation.

The tests cover:

| Test                     | Result |
| ------------------------ | ------ |
| Script exists            | PASS   |
| Bash syntax              | PASS   |
| Missing arguments        | PASS   |
| Invalid username         | PASS   |
| Invalid group            | PASS   |
| User creation            | PASS   |
| User existence           | PASS   |
| Primary group assignment | PASS   |
| Home directory creation  | PASS   |
| Bash shell assignment    | PASS   |
| Password aging           | PASS   |
| Duplicate-user detection | PASS   |

### Final Result

```text
====================================
TEST SUMMARY
====================================
Passed : 12
Failed : 0

[+] All tests passed
```

---

## 11. Observations

During development, the account was manually inspected using Linux administration commands before being automated.

The following observations were confirmed:

1. `useradd` created the requested account.
2. The home directory was automatically created.
3. The requested primary group was correctly assigned.
4. `/bin/bash` was assigned as the login shell.
5. Password-aging settings were successfully applied.
6. Duplicate account creation was prevented.
7. Invalid usernames and group names were rejected.
8. Non-privileged execution was rejected.
9. Automated tests reproduced the expected behavior consistently.

---

## 12. Security Considerations

Because the project modifies system account configuration, it must only be executed on systems where the operator has authorization.

The following practices were followed:

* Testing was performed in a controlled VM.
* Disposable test accounts were used.
* Passwords were not hard-coded.
* No credentials were stored in project files.
* Sensitive account databases were not included in the repository.
* Real system-specific information should be sanitized before publishing evidence.

---

## 13. Lessons Learned

This project provided practical experience with Linux account administration and Bash automation.

Key lessons include:

* Linux users and groups are separate account-management objects.
* A primary group can be assigned during account creation.
* Home-directory ownership depends on the account and group configuration.
* `chage` provides controls for password-aging policies.
* Administrative privileges should be explicitly checked.
* Input validation should occur before privileged operations.
* Exit codes are important for automation.
* Automated tests help detect regressions after script changes.
* System administration scripts should avoid embedding credentials.

---

## 14. Future Improvements

Possible future versions could include:

* Interactive mode
* Configuration files
* Optional supplementary groups
* Account expiration dates
* Dry-run functionality
* Structured logging
* Rollback support
* CSV-based bulk provisioning
* Integration with centralized identity systems

These features are intentionally outside the scope of the current implementation.

---

## 15. Final Result

The final Bash utility successfully provisions a Linux user account with a specified primary group, Bash shell, home directory, and password-aging policy.

The implementation was validated through an automated test suite with:

```text
12 tests passed
0 tests failed
```

**Project status: COMPLETE**
