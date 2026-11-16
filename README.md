# SSI Platform Engineer Exercise

This repository contains my solutions for the
SSI Platform Engineer technical exercise.

## Environment

- OS: CentOS Stream 10
- Shell: Bash
- Version Control: Git

## Tasks

1. Memory Check - memory_check.sh
2. CPU Check - cpu_check.sh
3. Disk Check - disk_check.sh

## Project Status

- [ ] Memory Check
- [ ] CPU Check
- [ ] Disk Check



## Memory Monitoring Script

The `memory_check.sh` script monitors system memory usage and compares it against user-defined warning and critical thresholds.

### Usage

```bash
./memory_check.sh -c <critical_threshold> -w <warning_threshold> -e <email_address>
```

### Parameters

| Parameter | Description |
|---|---|
| `-c` | Critical memory usage threshold (%) |
| `-w` | Warning memory usage threshold (%) |
| `-e` | Email address for critical alerts |

### Testing

**1. Normal Status**

```bash
./memory_check.sh -c 90 -w 80 -e admin@example.com
echo $?
```

Expected exit code: `0` (Normal)

**2. Warning Status**

```bash
./memory_check.sh -c 90 -w 20 -e admin@example.com
echo $?
```

Expected exit code: `1` (Warning)

**3. Critical Status**

```bash
./memory_check.sh -c 20 -w 10 -e admin@example.com
echo $?
```

Expected exit code: `2` (Critical)

### Exit Codes

| Exit Code | Description |
|---|---|
| `0` | Memory usage is below the warning threshold |
| `1` | Memory usage reached or exceeded the warning threshold |
| `2` | Memory usage reached or exceeded the critical threshold |
| `3` | Invalid or missing parameters |



## Email Notification Setup

The memory monitoring script supports email notifications when memory usage reaches the critical threshold.

### Requirements

- s-nail mail utility
- Gmail account with 2-Step Verification enabled
- Gmail App Password
- SMTP connection to smtp.gmail.com

### SMTP Configuration

Configure s-nail using a local `~/.mailrc` file:

```text
set v15-compat
set mta=smtps://smtp.gmail.com:465
set smtp-auth=login
set netrc-lookup
set from=YOUR_GMAIL_ADDRESS
```

Store SMTP credentials separately in `~/.netrc`:

```text
machine smtp.gmail.com login YOUR_GMAIL_ADDRESS password YOUR_APP_PASSWORD
```

Secure the configuration files:

```bash
chmod 600 ~/.mailrc
chmod 600 ~/.netrc
```

**Security Note:** Never commit SMTP credentials, Gmail App Passwords, or personal email configuration files to GitHub.

### Test Email Delivery

Run the following command, replacing the recipient with your email address:

```bash
echo "This is a test email from my CentOS memory monitoring project." | mail -v -s "CentOS SMTP Test" YOUR_GMAIL_ADDRESS
```

Check the command's exit status:

```bash
echo $?
```

Expected exit code: `0` (Successful command execution).


### Critical Memory Email Notification

When memory usage reaches or exceeds the configured critical threshold, the script automatically sends an email notification containing:

- Current memory usage and configured thresholds.
- Current memory information.
- Top 10 memory-consuming processes, including their PIDs.

The email subject follows this format:

`YYYYMMDD HH:MM memory_check - critical`

Email notifications are only sent when memory usage reaches the critical threshold.

**Example:**

```bash
./memory_check.sh -c 20 -w 10 -e your_email@gmail.com
```

**Expected behavior:**
- Exit code `2`: Critical memory usage; email notification sent.
- Exit code `1`: Warning memory usage; no email notification.
- Exit code `0`: Normal memory usage; no email notification.



## CPU CHECK (`cpu_check.sh`)

The CPU monitoring script measures CPU utilization by comparing CPU statistics from `/proc/stat` over a one-second interval.

### Features

- Calculates CPU utilization percentage.
- Accepts critical and warning thresholds through command-line options.
- Validates required parameters and threshold values.
- Returns the appropriate exit status:
  - `0` – Normal CPU usage.
  - `1` – Warning threshold reached.
  - `2` – Critical threshold reached.
  - `3` – Invalid parameters or calculation error.
- Sends an email notification when CPU usage reaches the critical threshold.
- Includes the top 10 CPU-consuming processes, their PIDs, and CPU utilization in the email report.

### Usage

```bash
./cpu_check.sh -c <critical_threshold> -w <warning_threshold> -e <email_address>
```

Example:

```bash
./cpu_check.sh -c 90 -w 80 -e your_email@gmail.com
```

### Critical Email Notification

When CPU usage reaches or exceeds the critical threshold, the script sends an email containing:

- Current CPU usage and configured thresholds.
- Top 10 CPU-consuming processes.
- Process IDs (PIDs), process names, and CPU utilization.

The email subject follows this format:

`YYYYMMDD HH:MM cpu_check - critical`

### Testing

Example commands for testing different threshold conditions:

```bash
# Normal
./cpu_check.sh -c 90 -w 80 -e your_email@gmail.com

# Warning
./cpu_check.sh -c 90 -w 0 -e your_email@gmail.com

# Critical (requires CPU usage of at least 1%)
./cpu_check.sh -c 1 -w 0 -e your_email@gmail.com
```



## DISK PARTITION CHECK (`disk_check.sh`)

The disk monitoring script uses the `df` command to retrieve filesystem and disk partition utilization.

### Features

- Monitors disk partition usage individually.
- Excludes temporary filesystems such as `tmpfs` and `devtmpfs`.
- Accepts critical and warning thresholds through command-line options.
- Identifies partitions that reach warning or critical thresholds.
- Determines the overall status based on the highest severity found.
- Returns the appropriate exit status:
  - `0` – Normal disk usage.
  - `1` – Warning threshold reached.
  - `2` – Critical threshold reached.
  - `3` – Invalid parameters.
- Sends an email notification when at least one partition reaches the critical threshold.
- Includes filesystem, total space, used space, available space, usage percentage, and mount point in the email report.

### Usage

```bash
./disk_check.sh -c <critical_threshold> -w <warning_threshold> -e <email_address>
```

Example:

```bash
./disk_check.sh -c 90 -w 80 -e your_email@gmail.com
```

### Critical Email Notification

When at least one monitored partition reaches or exceeds the critical threshold, the script sends an email containing the current disk partition information.

The email subject follows this format:

`YYYYMMDD HH:MM disk_check - critical`

### Testing

```bash
# Normal
./disk_check.sh -c 90 -w 80 -e your_email@gmail.com

# Warning
./disk_check.sh -c 90 -w 10 -e your_email@gmail.com

# Critical
./disk_check.sh -c 12 -w 10 -e your_email@gmail.com
```
