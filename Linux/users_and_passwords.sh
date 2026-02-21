#!/bin/bash

# Check if running as root and exit if not
if [ "$(id -u)" -ne 0 ]; then
    echo "users.sh run fail"
    exit 1
fi

# List of users that will be excluded
user_list=(
  "whiteteam" "datadog"
)

# Loop through all users on the device
while IFS=':' read -r username pass _; do
    username=$(echo "$username" | tr -d '[:space:]')

    # Skip system accounts (UID < 1000)
    uid=$(id -u "$username" 2>/dev/null)
    if [ -z "$uid" ] || [ "$uid" -lt 1000 ]; then
        continue
    fi

    # Input new password to be used on new accounts
    read -s -p "Enter new password for '$username': " new_pass
    echo

    
    if printf "%s\n" "${user_list[@]}" | grep -qxF "$username"; then
        echo "'$username' is approved."

        # Skip whiteteam and datadog users
        if [ "$username" = "whiteteam" ] || [ "$username" = "datadog" ]; then
            echo "Skipping white team/datadog."
            continue
        fi

        # If there's no new password, skip changing passwords
        if [ -z "$new_pass" ]; then
            echo "Skipping password change."
            continue
        fi

        # Change the user's password if possible
        echo "${username}:${new_pass}" | chpasswd
        if [ $? -eq 0 ]; then
            echo "Password updated for ${username}."
        else
            echo "Password update FAILED for ${username}."
        fi
    else
        # If the user isn't in the approved list, ask to delete them and print what happened
        read -p "Delete user '$username'? [y/n]: " confirm
        if [ "$confirm" = "y" ]; then
            deluser --remove-home "$username"
            if [ $? -eq 0 ]; then
                echo "User '$username' removed."
            else
                echo "Error removing user '$username'."
            fi
        else
            echo "Did not delete '$username'"
        fi
    fi
done < /etc/passwd
