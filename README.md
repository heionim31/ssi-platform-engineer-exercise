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
