echo "User cron jobs:"
if command -v crontab >/dev/null 2>&1; then
    crontab -l 2>/dev/null || echo "No user crontab"
else
    echo "crontab not found"
fi

echo -e "\nSystem cron jobs:"
if [ -d /etc/cron.d ]; then
    ls -1 /etc/cron.d/
fi

echo -e "\nUser bash startup files:"
for file in ~/.bashrc ~/.bash_profile ~/.profile; do
    if [ -f "$file" ]; then
        echo "    $file:"
        cat "$file"
    fi
done

echo -e "\nsystemd enabled services:"
if command -v systemctl >/dev/null 2>&1; then
    systemctl list-unit-files --type=service | grep enabled
else
    echo "systemctl not found"
fi
