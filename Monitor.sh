#!/bin/bash

LOG_FILE="/var/log/health_monitor.log"
SERVICES_FILE="services.txt"

TOTAL=0
HEALTHY=0
RECOVERED=0
FAILED=0

DRY_RUN=false

if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "Running in DRY-RUN mode"
fi

if [[ ! -f "$SERVICES_FILE" || ! -s "$SERVICES_FILE" ]]; then
    echo "Error: services.txt not found or empty"
    exit 1
fi

log_event() {
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP | $1 | $2 | $3" >> "$LOG_FILE"
}

while read -r SERVICE; do
    [[ -z "$SERVICE" ]] && continue

    ((TOTAL++))

    STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

    if [[ "$STATUS" == "active" ]]; then
        ((HEALTHY++))
    else
        echo "Service $SERVICE is not running"

        if [[ "$DRY_RUN" == true ]]; then
            echo "[DRY RUN] Would restart $SERVICE"
            log_event "$SERVICE" "RECOVERED" "INFO"
            ((RECOVERED++))
            continue
        fi

        systemctl restart "$SERVICE"
        sleep 5

        NEW_STATUS=$(systemctl is-active "$SERVICE" 2>/dev/null)

        if [[ "$NEW_STATUS" == "active" ]]; then
            echo "Service $SERVICE recovered"
            log_event "$SERVICE" "RECOVERED" "INFO"
            ((RECOVERED++))
        else
            echo "Service $SERVICE failed"
            log_event "$SERVICE" "FAILED" "ERROR"
            ((FAILED++))
        fi
    fi

done < "$SERVICES_FILE"

echo "-----------------------------"
echo "Summary:"
echo "Total Checked: $TOTAL"
echo "Healthy: $HEALTHY"
echo "Recovered: $RECOVERED"
echo "Failed: $FAILED"
echo "-----------------------------"

echo "User: $(whoami)"
echo "Host: $(hostname)"
