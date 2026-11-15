# BASH Scripting - Memory Scripting

#!/bin/bash

# Initialize variables
CRITICAL=""
WARNING=""
EMAIL=""

# Read command-line options
while getopts ":c:w:e:" opt; do
    case "$opt" in
        c)
            CRITICAL="$OPTARG"
            ;;
        w)
            WARNING="$OPTARG"
            ;;
        e)
            EMAIL="$OPTARG"
            ;;
        :)
            echo "Error: Option -$OPTARG requires an argument."
            exit 3
            ;;
        \?)
            echo "Error: Invalid option -$OPTARG."
            exit 3
            ;;
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
if (( CRITICAL < 0 || CRITICAL > 100 || WARNING < 0 || WARNING > 100 )); then
    echo "Error: Thresholds must be between 0 and 100."
    exit 3
fi

# Validate that critical threshold is greater than warning threshold
if (( CRITICAL <= WARNING )); then
    echo "Error: Critical threshold must be greater than warning threshold."
    exit 3
fi

# Get memory information
MEMORY_INFO=$(free -b | grep Mem:)
TOTAL_MEMORY=$(echo "$MEMORY_INFO" | awk '{print $2}')
USED_MEMORY=$(echo "$MEMORY_INFO" | awk '{print $3}')

# Calculate memory usage percentage
MEMORY_USAGE=$(( USED_MEMORY * 100 / TOTAL_MEMORY ))


# Display memory information
echo "Total Memory: $TOTAL_MEMORY bytes"
echo "Used Memory: $USED_MEMORY bytes"
echo "Memory Usage: ${MEMORY_USAGE}%"

# Check memory usage against thresholds
if (( MEMORY_USAGE >= CRITICAL )); then
    echo "CRITICAL: Memory usage is high!"
    exit 2

elif (( MEMORY_USAGE >= WARNING )); then
    echo "WARNING: Memory usage is elevated!"
    exit 1

else
    echo "OK: Memory usage is normal."
    exit 0
fi
