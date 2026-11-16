# SSI Platform Engineer Technical Exercise

## Overview

This project contains three Bash scripts for monitoring system resource utilization on Linux servers. Each script checks resource usage against configurable warning and critical thresholds and sends an email notification when a critical threshold is reached.

## Environment

- OS: CentOS Stream 10
- Shell: Bash
- Email Utility: s-nail
- SMTP: Gmail

## Project Structure

```text
ssi-platform-engineer-exercise/
├── memory_check.sh
├── cpu_check.sh
├── disk_check.sh
└── README.md
```

## Monitoring Scripts

### 1. Memory Monitoring (`memory_check.sh`)

The memory monitoring script calculates memory utilization using system memory statistics retrieved from the `free` command. It compares the current usage against the configured warning and critical thresholds.

### 2. CPU Monitoring (`cpu_check.sh`)

The CPU monitoring script calculates CPU utilization by comparing CPU statistics retrieved from `/proc/stat` over a one-second interval. It uses the calculated utilization to determine the system's current status.

### 3. Disk Monitoring (`disk_check.sh`)

The disk monitoring script checks filesystem utilization using the `df` command. It evaluates each disk partition against the configured warning and critical thresholds and determines the overall disk status.

### Critical Email Notifications

When a critical threshold is reached, the corresponding script sends an email containing:

| Script | Email Information |
|---|---|
| `memory_check.sh` | Top 10 memory-consuming processes, including PIDs |
| `cpu_check.sh` | Top 10 CPU-consuming processes, including PIDs |
| `disk_check.sh` | Disk partition information |

## Usage

Run each script using the following format:

```bash
./memory_check.sh -c 90 -w 80 -e email@example.com
./cpu_check.sh -c 90 -w 80 -e email@example.com
./disk_check.sh -c 90 -w 80 -e email@example.com
```

### Parameters

| Parameter | Description |
|---|---|
| `-c` | Critical threshold percentage |
| `-w` | Warning threshold percentage |
| `-e` | Email address for critical notifications |

**Validation Rules:**
- All parameters are required.
- Thresholds must be numeric values between 0 and 100.
- The critical threshold must be greater than the warning threshold.

### Exit Codes

| Code | Description |
|---|---|
| `0` | Normal – usage is below the warning threshold |
| `1` | Warning – usage has reached the warning threshold |
| `2` | Critical – usage has reached the critical threshold |
| `3` | Invalid or missing parameters, or calculation error |

## Email Configuration

The scripts use `s-nail` to send critical alert notifications through Gmail SMTP.

Install the required package:

```bash
sudo dnf install s-nail -y
```

Configure SMTP credentials locally using `~/.mailrc` and `~/.netrc`, then set the appropriate file permissions:

```bash
chmod 600 ~/.mailrc ~/.netrc
```

**Security:** SMTP credentials are stored outside the project repository and must never be committed to GitHub.

## Testing

The following commands demonstrate how to test different monitoring conditions:

```bash
# Normal
./memory_check.sh -c 90 -w 80 -e email@example.com

# Warning
./memory_check.sh -c 90 -w 10 -e email@example.com

# Critical
./memory_check.sh -c 13 -w 10 -e email@example.com
```

Adjust thresholds according to actual system utilization. For CPU testing, additional CPU load may be required to reach the critical threshold.

