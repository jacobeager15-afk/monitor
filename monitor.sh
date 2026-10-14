#!/bin/bash

# --- CONFIGURATION ---
# Set your thresholds (in percentage)
CPU_THRESHOLD=80
RAM_THRESHOLD=85

# Log file location
LOG_FILE="$HOME/system_monitor.log"

echo "=== System Monitoring Started (Press Ctrl+C to stop) ==="
echo "Logging data to: $LOG_FILE"
echo "-----------------------------------------------------"

# Continuous monitoring loop (runs every 5 seconds)
while true; do
    # Get current timestamp
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Calculate CPU usage (100% minus idle time from top command)
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    # Convert CPU usage to an integer for comparison
    CPU_INT=$(printf "%.0f" "$CPU_USAGE")

    # Calculate RAM usage percentage using the 'free' command
    RAM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    RAM_INT=$(printf "%.0f" "$RAM_USAGE")

    # Format the log line
    LOG_ENTRY="[$TIMESTAMP] CPU: ${CPU_INT}% | RAM: ${RAM_INT}%"
    
    # Log everything to the file
    echo "$LOG_ENTRY" >> "$LOG_FILE"

    # Print warnings to terminal if thresholds are exceeded
    if [ "$CPU_INT" -gt "$CPU_THRESHOLD" ] || [ "$RAM_INT" -gt "$RAM_THRESHOLD" ]; then
        echo -e "\e[1;31m[WARNING] $LOG_ENTRY - High resource usage detected!\e[0m"
    else
        echo "$LOG_ENTRY"
    fi

    # Wait 5 seconds before checking again
    sleep 5
done
