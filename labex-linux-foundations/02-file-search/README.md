# LABEX Project 02 — File Search

## Overview

This project is part of the LABEX Linux Foundations track.

The objective is to build a Bash-based file search utility that allows a user to search recursively for files matching a specified filename pattern.

The project uses the Linux `find` command as its core search mechanism and adds argument validation, directory validation, result counting, and no-result handling.

## Objectives

The tool should be able to:

* Search a specified directory recursively
* Search for files using filename patterns
* Accept a directory as an argument
* Accept a filename pattern as an argument
* Validate command-line arguments
* Validate that the search directory exists
* Report when no matching files are found
* Count matching files
* Return useful error messages

## Technologies

* Linux
* Bash
* `find`
* `grep`
* `wc`
* Shell variables
* Functions
* Command-line arguments
* Conditional statements

## Project Structure

```text id="x1u5cm"
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

## Usage

Make the script executable:

```bash id="9v53wt"
chmod +x scripts/file_search.sh
```

Basic syntax:

```bash id="w4q8yo"
./scripts/file_search.sh <directory> <filename-pattern>
```

### Search for Markdown files

```bash id="gq0x5h"
./scripts/file_search.sh . "*.md"
```

Example:

```text id="t6yyf8"
==================================
           LABEX FILE SEARCH
==================================

[ SEARCH RESULTS]
Directory : .
Pattern : *.md

./docs/lab-report.md
./README.md

Total files found: 2
```

### Search for Shell scripts

```bash id="s2c9jw"
./scripts/file_search.sh . "*.sh"
```

### Search with no matching files

```bash id="mbgqsk"
./scripts/file_search.sh . "*.pdf"
```

Expected:

```text id="8d0k4n"
No matching files found.
```

### Invalid directory

```bash id="n7zq21"
./scripts/file_search.sh /does/not/exist "*.txt"
```

Expected:

```text id="8y9m3r"
[ERROR] Directory does not exist: /does/not/exist
```

### Missing arguments

```bash id="ybrk7f"
./scripts/file_search.sh
```

Expected:

```text id="j8s0r3"
Usage: ./scripts/file_search.sh <directory> <filename-pattern>
```

## Core Implementation

The project uses the Linux `find` command:

```bash id="d3xj71"
find "$search_dir" -type f -name "$pattern"
```

The command searches recursively from the specified directory.

### `-type f`

Restricts results to regular files.

### `-name`

Matches files against the supplied filename pattern.

For example:

```bash id="6xg7qp"
find . -type f -name "*.md"
```

searches recursively for Markdown files.

## Command-Line Arguments

The script accepts two arguments:

```text id="9z5o2g"
$1 → Search directory
$2 → Filename pattern
```

The number of supplied arguments is checked using:

```bash id="u9p0w6"
$#
```

The script requires exactly two arguments.

## Input Validation

The project checks whether the requested directory exists:

```bash id="h7s4p3"
if [ ! -d "$search_dir" ]; then
    echo "[ERROR] Directory does not exist: $search_dir"
    return 1
fi
```

This prevents the tool from attempting to search an invalid location.

## No-Match Handling

Search results are captured and counted.

If no files match the supplied pattern, the script reports:

```text id="rxq3s5"
No matching files found.
```

This is more useful than silently returning an empty result.

## Testing

Automated tests are stored in:

```text id="1m5k3z"
tests/test_file_search.sh
```

Run:

```bash id="1r1v3b"
cd tests
./test_file_search.sh
```

The test suite verifies:

```text id="c2i5z6"
✓ Script exists
✓ Markdown file search
✓ Shell script search
✓ No-match handling
✓ Argument validation
✓ Invalid directory handling
```

Final test result:

```text id="j5n6qv"
[+] Testing file_search.sh

[PASS] Script exists
[PASS] Markdown file search
[PASS] Shell script search
[PASS] No-match handling
[PASS] Argument validation
[PASS] Invalid directory handling

[+] All tests passed
```

## Development Notes

The first version of the project implemented basic recursive filename searching.

During development, additional validation was added to handle:

* Missing arguments
* Invalid directories
* Empty search results
* Result counting

An issue was also identified during automated testing where the test script was executed from the `tests/` directory. The relative path `.` therefore referred to the test directory instead of the project root.

The tests were corrected to use `..` as the search root.

This demonstrated an important Linux concept:

```text id="7p0v1y"
.  = current working directory
.. = parent directory
```

## Security Considerations

The tool performs local filesystem searches and does not perform network scanning or exploitation.

Users should avoid unnecessarily searching sensitive system locations when running the tool.

Care should also be taken when handling output from directories containing confidential information.

## Future Improvements

Potential future versions could add:

* Search by file size
* Search by modification time
* Search by permissions
* Search by owner
* Case-insensitive searching
* Regular-expression matching
* Output to a file
* JSON output
* Colored terminal output
* Interactive mode
* More extensive automated tests

## Status

**LABEX Project 02 — Completed Version 2**

Implementation: **Complete**
Validation: **Complete**
Automated Testing: **Passed**
Documentation: **Complete**
Evidence: **Captured**

## LABEX

```text id="l7z7bb"
Understand
    ↓
Design
    ↓
Build
    ↓
Test
    ↓
Debug
    ↓
Refactor
    ↓
Document
    ↓
Publish
```
