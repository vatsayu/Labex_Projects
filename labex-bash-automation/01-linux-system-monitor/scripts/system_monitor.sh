#!/usr/bin/env bash

set -u

# ==========================================
# Linux System Monitor
# ==========================================

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CPU_THRESHOLD=${CPU_THRESHOLD:-80}
MEMORY_THRESHOLD=${MEMORY_THRESHOLD:-80}
DISK_THRESHOLD=${DISK_THRESHOLD:-80}
WARNINGS=0

print_header() {
    echo "=========================================="
    echo "          LINUX SYSTEM MONITOR"
    echo "=========================================="
}

get_system_information() {
    HOSTNAME_VALUE=$(hostname)
    OS_NAME=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
    KERNEL_VERSION=$(uname -r)
    UPTIME_VALUE=$(uptime -p)
}

get_resource_usage() {
    CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {
        usage = 100 - $8
        printf "%.2f", usage
    }')

    MEMORY_USAGE=$(free | awk '/Mem:/ {
        printf "%.2f", ($3/$2) * 100
    }')

    DISK_USAGE=$(df -P / | awk 'NR==2 {
        gsub("%","",$5)
        print $5
    }')
}

get_network_information() {
    IP_ADDRESSES=$(hostname -I 2>/dev/null || echo "Unavailable")
}

get_service_information() {
    USER_COUNT=$(who | wc -l)

    SERVICE_COUNT=$(systemctl list-units \
        --type=service \
        --state=running \
        --no-pager 2>/dev/null |
        awk 'END {print NR-6}')
}

display_information() {
    echo "Timestamp       : $TIMESTAMP"
    echo "Hostname        : $HOSTNAME_VALUE"
    echo "Operating System: $OS_NAME"
    echo "Kernel          : $KERNEL_VERSION"
    echo "Uptime          : $UPTIME_VALUE"
    echo "------------------------------------------"
    echo "CPU Usage       : ${CPU_USAGE}%"
    echo "Memory Usage    : ${MEMORY_USAGE}%"
    echo "Disk Usage /    : ${DISK_USAGE}%"
    echo "Logged-in Users : $USER_COUNT"
    echo "IP Addresses    : $IP_ADDRESSES"
    echo "Running Services: $SERVICE_COUNT"
    echo "------------------------------------------"
}

check_cpu() {
    if awk "BEGIN {exit !($CPU_USAGE >= $CPU_THRESHOLD)}"; then
        echo "[WARNING] CPU usage is above ${CPU_THRESHOLD}%"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "[OK] CPU usage is within limits"
    fi
}

check_memory() {
    if awk "BEGIN {exit !($MEMORY_USAGE >= $MEMORY_THRESHOLD)}"; then
        echo "[WARNING] Memory usage is above ${MEMORY_THRESHOLD}%"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "[OK] Memory usage is within limits"
    fi
}

check_disk() {
    if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
        echo "[WARNING] Disk usage is above ${DISK_THRESHOLD}%"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "[OK] Disk usage is within limits"
    fi
}

display_health_status() {
    echo "------------------------------------------"

    if [ "$WARNINGS" -eq 0 ]; then
        echo "System Health   : HEALTHY"
    else
        echo "System Health   : WARNING"
    fi

    echo "=========================================="
}

main() {
    print_header
    get_system_information
    get_resource_usage
    get_network_information
    get_service_information
    display_information
    check_cpu
    check_memory
    check_disk
    display_health_status

    return "$WARNINGS"
}

main
exit $?
