
#!/bin/bash

# Parse command-line options
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



# Read the initial CPU statistics
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

IDLE_PREV=$(( idle + iowait ))
TOTAL_PREV=$(( user + nice + system + idle + iowait + irq + softirq + steal ))

# Wait one second before taking another reading
sleep 1

# Read the latest CPU statistics
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

IDLE_CURRENT=$(( idle + iowait ))
TOTAL_CURRENT=$(( user + nice + system + idle + iowait + irq + softirq + steal ))

# Calculate CPU usage
TOTAL_DIFF=$(( TOTAL_CURRENT - TOTAL_PREV ))
IDLE_DIFF=$(( IDLE_CURRENT - IDLE_PREV ))

if (( TOTAL_DIFF > 0 )); then
    CPU_USAGE=$(( (TOTAL_DIFF - IDLE_DIFF) * 100 / TOTAL_DIFF ))
else
    echo "ERROR: Unable to calculate CPU usage."
    exit 3
fi

echo "CPU Usage: ${CPU_USAGE}%"




# Check CPU usage against thresholds
if (( CPU_USAGE >= CRITICAL )); then

    echo "CRITICAL: CPU usage is high!"

    # Generate email subject with timestamp
    SUBJECT="$(date '+%Y%m%d %H:%M') cpu_check - critical"

    # Generate and send email notification
    if {
        echo "CRITICAL: CPU usage has reached the critical threshold."
        echo ""
        echo "CPU Usage: ${CPU_USAGE}%"
        echo "Critical Threshold: ${CRITICAL}%"
        echo "Warning Threshold: ${WARNING}%"
        echo ""
        echo "Top 10 CPU-Consuming Processes:"
        ps -eo pid,comm,%cpu --sort=-%cpu | head -n 11
    } | mail -s "$SUBJECT" "$EMAIL"; then

        echo "Critical alert email sent successfully."

    else

        echo "ERROR: Failed to send critical alert email."

    fi

    exit 2

elif (( CPU_USAGE >= WARNING )); then

    echo "WARNING: CPU usage is elevated!"
    exit 1

else

    echo "OK: CPU usage is normal."
    exit 0

fi

