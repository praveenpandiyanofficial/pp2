#!/bin/bash

# Directory where service files and logs are stored
SERVICE_DIR="$HOME/pp2_services"
LOG_DIR="/var/log"

mkdir -p "$SERVICE_DIR"
mkdir -p "$LOG_DIR"

# Colors
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

show_help() {
    echo "Usage: bash pp2.sh [command] [options]"
    echo
    echo "Commands:"
    echo "  start <command> --name <service_name>   Create and start a managed service"
    echo "  stop <service_name>                     Stop the service"
    echo "  restart <service_name>                  Restart the service"
    echo "  list                                    List all managed services"
    echo "  logs <service_name>                     Show last 50 lines of service log"
    echo "  help                                    Show this help message"
}

service_file() {
    echo "$SERVICE_DIR/$1.service"
}

log_file() {
    echo "$LOG_DIR/$1.log"
}

start_service() {
    local cmd="$1"
    local name="$2"
    local svc_file
    local logf

    svc_file=$(service_file "$name")
    logf=$(log_file "$name")

    if [ -f "$svc_file" ]; then
        echo "Service '$name' already exists!"
        return
    fi

    # Create a systemd service file in SERVICE_DIR
    cat > "$svc_file" <<EOL
[Unit]
Description=Managed Service $name
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME
ExecStart=$cmd
Restart=always
StandardOutput=append:$logf
StandardError=append:$logf

[Install]
WantedBy=multi-user.target
EOL

    # Start the service
    bash -c "$cmd &"
    echo "Service '$name' created and started!"
}

stop_service() {
    local name="$1"
    pkill -f "$(cat $(service_file "$name") 2>/dev/null | grep ExecStart | cut -d= -f2-)"
    echo "Service '$name' stopped!"
}

restart_service() {
    local name="$1"
    stop_service "$name"
    local cmd
    cmd=$(grep ExecStart "$(service_file "$name")" | cut -d= -f2-)
    bash -c "$cmd &"
    echo "Service '$name' restarted!"
}

list_services() {
    printf "+--------------------+---------+-----------------------+\n"
    printf "| %-18s | %-7s | %-21s |\n" "Service Name" "Status" "Log File"
    printf "+--------------------+---------+-----------------------+\n"

    for svc in "$SERVICE_DIR"/*.service; do
        [ -e "$svc" ] || continue
        name=$(basename "$svc" .service)
        logf=$(log_file "$name")
        pid=$(pgrep -f "$(grep ExecStart "$svc" | cut -d= -f2-)")
        if [ -n "$pid" ]; then
            status="${GREEN}running${RESET}"
        else
            status="${RED}stopped${RESET}"
        fi
        printf "| %-18s | %-7b | %-21s |\n" "$name" "$status" "$logf"
    done
    printf "+--------------------+---------+-----------------------+\n"
}

show_logs() {
    local name="$1"
    local logf
    logf=$(log_file "$name")
    if [ -f "$logf" ]; then
        tail -n 50 "$logf"
    else
        echo "Log file for '$name' not found."
    fi
}

# Main
cmd="$1"
shift

case "$cmd" in
    start)
        service_cmd="$1"
        shift
        if [ "$1" == "--name" ]; then
            service_name="$2"
            shift 2
            start_service "$service_cmd" "$service_name"
        else
            echo "Usage: start <command> --name <service_name>"
        fi
        ;;
    stop)
        stop_service "$1"
        ;;
    restart)
        restart_service "$1"
        ;;
    list)
        list_services
        ;;
    logs)
        show_logs "$1"
        ;;
    help|*)
        show_help
        ;;
esac
