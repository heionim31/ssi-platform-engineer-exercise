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

# Get memory information
MEMORY_INFO=$(free -b | grep Mem:)
TOTAL_MEMORY=$(echo "$MEMORY_INFO" | awk '{print $2}')
USED_MEMORY=$(echo "$MEMORY_INFO" | awk '{print $3}')

# Calculate memory usage percentage
MEMORY_USAGE=$(( USED_MEMORY * 100 / TOTAL_MEMORY ))

# Display results
echo "Critical Threshold: ${CRITICAL}%"
echo "Warning Threshold: ${WARNING}%"
echo "Email Address: $EMAIL"
echo "Total Memory: $TOTAL_MEMORY bytes"
echo "Used Memory: $USED_MEMORY bytes"
echo "Memory Usage: ${MEMORY_USAGE}%"
