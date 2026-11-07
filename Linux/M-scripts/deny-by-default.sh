#!/bin/bash
#Deny by Default
# Usage: ./DbD.sh 80 443 3306

if [ $# -eq 0 ]; then
    echo "Please provide the ports you want to allow. Example: ./DbD.sh 22 80"
    exit 1
fi

iptables -F
iptables -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

PROTECTED_RANGES=(
    "172.16.1.0/24"
    "10.3.1.99/32"
)

for range in "${PROTECTED_RANGES[@]}"; do
    iptables -A INPUT -s "$range" -j ACCEPT
    iptables -A FORWARD -s "$range" -j ACCEPT
    iptables -A FORWARD -d "$range" -j ACCEPT
done

iptables -A INPUT -p tcp --dport "514" -j ACCEPT
iptables -A INPUT -p udp --dport "514" -j ACCEPT

ALLOWED_DOMAINS=(
    "scoring.irsec.club"
)

for domain_pattern in "${ALLOWED_DOMAINS[@]}"; do
    domain="${domain_pattern#*.}"
    mapfile -t addresses < <(getent ahostsv4 "$domain" | awk '{print $1}' | sort -u)

    if [ "${#addresses[@]}" -eq 0 ]; then
        echo "Error: Could not resolve $domain_pattern; refusing to apply an incomplete allowlist." >&2
        exit 1
    fi

    for address in "${addresses[@]}"; do
        iptables -A INPUT -s "$address" -j ACCEPT
        iptables -A FORWARD -s "$address" -j ACCEPT
        iptables -A FORWARD -d "$address" -j ACCEPT
        iptables -A OUTPUT -d "$address" -j ACCEPT
        echo "Allowed communication with $domain_pattern ($address)"
    done
done

for port in "$@"; do
    iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
    iptables -A INPUT -p udp --dport "$port" -j ACCEPT
    echo "Allowed inbound port: $port"
done

echo "Allow rules applied. All other inbound traffic is dropped."
