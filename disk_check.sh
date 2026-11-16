# BASH Scripting - Disk Partition Scripting
#!/bin/bash

# Initialize variables
CRITICAL=""
WARNING=""
EMAIL=""

# Read command-line options
while getopts ":c:w:e:" opt; do
    case "$opt" in
        c) CRITICAL="$OPTARG" ;;
        w) WARNING="$OPTARG" ;;
        e) EMAIL="$OPTARG" ;;
        :) echo "Error: Option -$OPTARG requires an argument."; exit 3 ;;
        \?) echo "Error: Invalid option -$OPTARG."; exit 3 ;;
    esac
done

# Check if all required parameters were provided
if [[ -z "$CRITICAL" || -z "$WARNING" || -z "$EMAIL" ]]; then
    echo "Usage: $0 -c <critical_threshold> -w <warning_threshold> -e <email_address>"
    exit 3
fi

# Validate that thresholds contain only numbers
if ! [[ "$CRITICAL" =~ ^[0-9]+$ ]] || ! [[ "$WARNING" =~ ^[0-9]+$ ]]; then
    echo "Error: Thresholds must be numeric values."
    exit 3
fi

# Validate that thresholds are between 0 and 100
if (( CRITICAL > 100 || WARNING > 100 )); then
    echo "Error: Thresholds must be between 0 and 100."
    exit 3
fi

# Validate that critical threshold is greater than warning threshold
if (( CRITICAL <= WARNING )); then
    echo "Error: Critical threshold must be greater than warning threshold."
    exit 3
fi


# Retrieve disk partition information
DISK_INFO=$(df -P -x tmpfs -x devtmpfs)

# Initialize overall status
OVERALL_STATUS=0

echo "Disk Partition Usage:"
echo ""

while IFS= read -r line; do

    # Skip the header row
    [[ "$line" == Filesystem* ]] && continue

    # Extract disk information
    read -r filesystem blocks used available usage mountpoint <<< "$line"

    # Remove the percentage symbol
    usage=${usage%\%}

    # Display partition information
    echo "Filesystem: $filesystem"
    echo "Used Space: $used"
    echo "Available Space: $available"
    echo "Usage: ${usage}%"
    echo "Mount Point: $mountpoint"

    # Check partition usage against thresholds
    if (( usage >= CRITICAL )); then

        echo "Status: CRITICAL"
        OVERALL_STATUS=2

    elif (( usage >= WARNING )); then

        echo "Status: WARNING"

        if (( OVERALL_STATUS < 1 )); then
            OVERALL_STATUS=1
        fi

    else

        echo "Status: NORMAL"

    fi

    echo "--------------------------------"

done <<< "$DISK_INFO"


# Display overall disk status
if (( OVERALL_STATUS == 2 )); then

    echo "CRITICAL: One or more disk partitions have reached the critical threshold."

    # Generate email subject with timestamp
    SUBJECT="$(date '+%Y%m%d %H:%M') disk_check - critical"

    # Generate and send email notification
    if {
        echo "CRITICAL: One or more disk partitions have reached the critical threshold."
        echo ""
        echo "Critical Threshold: ${CRITICAL}%"
        echo "Warning Threshold: ${WARNING}%"
        echo ""
        echo "Current Disk Partition Information:"
        echo "$DISK_INFO"
    } | mail -s "$SUBJECT" "$EMAIL"; then

        echo "Critical alert email sent successfully."

    else

        echo "ERROR: Failed to send critical alert email."

    fi

    exit 2

elif (( OVERALL_STATUS == 1 )); then

    echo "WARNING: One or more disk partitions have reached the warning threshold."
    exit 1

else

    echo "OK: All disk partitions are within normal usage."
    exit 0

fi

