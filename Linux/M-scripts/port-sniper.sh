#!/bin/bash
#PortSniper
# Usage: ./PortSniper.sh <port_number>
PORT=$1

if [ -z "$PORT" ]; then
    echo "Specify a port to kill. Usage: ./PortSniper.sh 4444"
    exit 1
fi

# Find PIDs using the port
PIDS=$(lsof -t -i:"$PORT")

if [ -z "$PIDS" ]; then
    echo "No active processes found on port $PORT."
else
    for PID in $PIDS; do
        # Log it for your IR report before killing it!
        ps -p "$PID" -o comm,args >> /root/IR_Killed_Processes.log
        kill -9 "$PID"
        echo "Killed Process $PID operating on port $PORT"
    done
fi
