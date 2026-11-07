#!/bin/bash
#QuickShot
DATE=$(date +%Y%m%d_%H%M)
OUT="IR_Snapshot_$DATE.txt"

echo "=== ACTIVE CONNECTIONS ===" >> $OUT
ss -tuplan >> $OUT
echo -e "\n=== RUNNING PROCESSES ===" >> $OUT
ps aux >> $OUT
echo -e "\n=== CRON JOBS  ===" >> $OUT
for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l 2>/dev/null; done >> $OUT

echo "Snapshot saved to $OUT"
