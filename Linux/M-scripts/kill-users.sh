#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)."
  exit 1
fi

AUTHORIZED_USERS=("scrutineer" "techdirector" "crewchief" "firecrew" "jackcrew" "garagecrew" "celebrity" "pitlaner" "reserve" "gunners")
EXEMPT_USERS=("whiteteam" "blackteam" "datadog" "dd-agent")

is_exempt() {
    local target_user="$1"
    for u in "${AUTHORIZED_USERS[@]}" "${EXEMPT_USERS[@]}"; do
        if [[ "$target_user" == "$u" ]]; then
            return 0 # True, user is exempt
        fi
    done
    return 1 
}

read -p "Enter the new password hash for authorized users: " PASSWD_HASH
echo ""

echo "--- Updating Authorized Users ---"
for user in "${AUTHORIZED_USERS[@]}"; do
    if id "$user" &>/dev/null; then
        # The -e flag tells chpasswd to treat the input as already encrypted
        echo "$user:$PASSWD_HASH" | chpasswd -e
        echo "[+] Password updated for $user"
    else
        echo "[-] User $user does not exist on this system (skipping)."
    fi
done

echo "--- Disabling Unauthorized Standard Users ---"
for user in $(awk -F: '$3 >= 1000 && $3 <= 60000 {print $1}' /etc/passwd); do
    if ! is_exempt "$user"; then
        usermod -L "$user"
        usermod -s /usr/sbin/nologin "$user"
        echo "[!] Disabled unauthorized user: $user"
    else
        echo "[i] Skipped exempt/authorized user: $user"
    fi
done

echo "--- Locking Password Auth for System Users ---"
for sys_user in $(awk -F: '$3 > 0 && $3 < 1000 {print $1}' /etc/passwd); do
    if ! is_exempt "$sys_user"; then
        usermod -L "$sys_user"
        echo "[!] Locked password authentication for system user: $sys_user"
    fi
done

echo "Done."
