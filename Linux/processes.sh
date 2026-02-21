#!/bin/bash

# Loop until the user quits
while true; do
    read -p "Keyword to search for (blank to quit): " keyword

    # Check if the user inputed a keyword to search for and quit if not
    if [ -z "$keyword" ]; then
        echo "Exiting"
        continue
    fi

    # Get matching processes (exclude grep itself)
    matches=$(ps aux | grep -i -- "$keyword" | grep -v grep)

    # Continues if no matching processes are found
    if [ -z "$matches" ]; then
        echo "No matching processes found."
        echo
        continue
    fi

    # Prints the matching processes
    echo "Matching processes:"
    echo "$matches"
    echo

    # Input PIDs to kill 
    read -p "Enter PID(s) to kill (separated by spaces), or press Enter for none: " pids

    # If PIDs are entered, then for each PID check that it is just numerals, try to kill it (hiding error messages), and print success/failure message
    if [ -n "$pids" ]; then
        for pid in $pids; do
            if [[ "$pid" =~ ^[0-9]+$ ]]; then
                if kill "$pid" 2>/dev/null; then
                    echo "Killed PID $pid"
                else
                    echo "Failed to kill PID $pid"
                fi
            else
                echo "Invalid PID: $pid"
            fi
        done
        echo
    fi
done
