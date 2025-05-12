#!/bin/bash

LOG_DOSYASI="/var/log/engellenen_ipler.log"

echo "Engellenen IP'ler kontrol ediliyor..."
ENGELLENEN_IPLER=$(sudo fail2ban-client status sshd | grep "Banned IP list" | awk '{print $NF}')

GUNCEL_ZAMAN=$(date +"%Y-%m-%d %H:%M:%S")

if [ -n "$ENGELLENEN_IPLER" ]; then
	echo "[$GUNCEL_ZAMAN] Engellenen IP'ler: $ENGELLENEN_IPLER" >> $LOG_DOSYASI
	echo "Engellenen IP'ler: $ENGELLENEN_IPLER"
else
	echo "[$GUNCEL_ZAMAN] Su anda engellenen IP yok." >> $LOG_DOSYASI
	echo "Su anda engellenen IP yok."
fi

ENGELLEME_SURESI=$(grep "bantime" /etc/fail2ban/jail.local | grep -v "#" | awk '{print $3}')
echo "Engelleme suresi: $ENGELLEME_SURESI saniye"
