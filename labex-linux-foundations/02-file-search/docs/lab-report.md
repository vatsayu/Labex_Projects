# LABEX Project 02 — File Search

## 1. Project Information

**Project:** File Search
**Track:** Linux Foundations
**Implementation:** Bash
**Environment:** Kali Linux
**Version:** 2.0
**Status:** Completed

## 2. Objective

The objective of this project was to create a Bash utility capable of recursively searching a specified directory for files matching a user-provided filename pattern.

The project also introduces basic command-line validation and error handling.

## 3. Requirements

The utility should:

1. Accept a search directory.
2. Accept a filename pattern.
3. Search recursively.
4. Search only regular files.
5. Display matching files.
6. Count matching results.
7. Handle empty search results.
8. Handle invalid directories.
9. Handle missing arguments.

## 4. Environment

The project was developed and tested inside the LABEX Linux Foundations environment using Kali Linux.

## 5. Tools Used

```text id="th5kw4"
Bash
find
grep
wc
Linux filesystem
Shell functions
Command-line arguments
Conditional expressions
```

## 6. Project Structure

```text id="5ldg7v"
02-file-search/
├── README.md
├── docs/
│   └── lab-report.md
├── output/
│   └── sample-file-search.txt
├── screenshots/
│   ├── file-search-output.png
│   └── file-search-tests.png
├── scripts/
│   └── file_search.sh
└── tests/
    └── test_file_search.sh
```

## 7. Initial Implementation

The first implementation focused on the core search operation:

```bash id="9y3gxn"
find "$search_dir" -type f -name "$pattern"
```

The script accepted:

```text id="0jpvak"
$1 → Directory
$2 → Filename pattern
```

Example:

```bash id="yy1q3z"
./scripts/file_search.sh . "*.md"
```

## 8. V2 Improvements

The second version added input validation and result handling.

### Argument Validation

The script checks that exactly two arguments are supplied.

```bash id="2zzj7x"
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <filename-pattern>"
    exit 1
fi
```

### Directory Validation

The search directory is checked before executing the search:

```bash id="gquqxf"
if [ ! -d "$search_dir" ]; then
    echo "[ERROR] Directory does not exist: $search_dir"
    return 1
fi
```

### Result Handling

Search results are captured and counted.

If the count is zero, the user receives:

```text id="3zj7v2"
No matching files found.
```

Otherwise, the results and total count are displayed.

## 9. Testing

Automated tests were created in:

```text id="l1j24p"
tests/test_file_search.sh
```

The following scenarios were tested.

### Test 1 — Script Exists

Result:

```text id="2p5pvo"
[PASS] Script exists
```

### Test 2 — Markdown Search

Command:

```bash id="3g0aqh"
./scripts/file_search.sh . "*.md"
```

Result:

```text id="g7ql7f"
[PASS] Markdown file search
```

### Test 3 — Shell Script Search

Command:

```bash id="k4juxo"
./scripts/file_search.sh . "*.sh"
```

Result:

```text id="x2v8l8"
[PASS] Shell script search
```

### Test 4 — No Matching Files

Command:

```bash id="kdb2u5"
./scripts/file_search.sh . "*.pdf"
```

Result:

```text id="5m3g1y"
[PASS] No-match handling
```

### Test 5 — Missing Arguments

Command:

```bash id="f4gy2v"
./scripts/file_search.sh
```

Result:

```text id="4ep1sh"
[PASS] Argument validation
```

### Test 6 — Invalid Directory

Command:

```bash id="0sf7rh"
./scripts/file_search.sh /does/not/exist "*.txt"
```

Result:

```text id="17d5z6"
[PASS] Invalid directory handling
```

### Final Test Result

```text id="eqe6dy"
[+] Testing file_search.sh

[PASS] Script exists
[PASS] Markdown file search
[PASS] Shell script search
[PASS] No-match handling
[PASS] Argument validation
[PASS] Invalid directory handling

[+] All tests passed
```

## 10. Debugging Observation

During automated testing, the Markdown search initially failed.

The cause was the difference between the current working directory and the project directory.

The test was executed from:

```text id="ivb3qh"
02-file-search/tests/
```

Therefore:

```bash id="s3w8sd"
.
```

referred to the `tests` directory.

The test was corrected to use:

```bash id="c2k5xz"
..
```

which refers to the project root.

This reinforced the distinction between:

```text id="qj1q2m"
.   → current directory
..  → parent directory
```

## 11. Observations

The final tool successfully searched the project directory for multiple file patterns.

Example Markdown results:

```text id="e9u6jq"
./docs/lab-report.md
./README.md
```

Example Shell results:

```text id="h0a1vz"
./scripts/file_search.sh
./tests/test_file_search.sh
```

The utility also correctly handled cases where no matching files existed.

## 12. Security Considerations

The project performs local filesystem searches.

No external network interaction is required.

The tool should be used responsibly when searching sensitive directories because search results may reveal filenames or paths that contain confidential information.

Public documentation should use sanitized example output where necessary.

## 13. Learning Outcomes

This project provided practical experience with:

* Bash functions
* Command-line arguments
* `$#`, `$1`, and `$2`
* Conditional statements
* `find`
* `grep`
* `wc`
* Local filesystem traversal
* Input validation
* Error handling
* Relative paths
* Automated Bash testing
* Debugging

## 14. Future Improvements

Future versions could support:

* File size filters
* Modification-time filters
* Permission filters
* Owner filters
* Case-insensitive search
* Regular expressions
* JSON output
* Report generation
* Interactive search
* More comprehensive testing

## 15. Result

The project successfully produced a functional Bash file-search utility with input validation and automated tests.

All six automated test cases passed.

**Final Status: COMPLETED**

## 16. Scope and Ethics

The project is intended for Linux administration and scripting education.

Testing was performed against the local LABEX project environment.

No unauthorized systems were accessed or scanned.
