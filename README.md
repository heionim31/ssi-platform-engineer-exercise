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
