#!/bin/bash

EPOSTA="kullanici1@ornek.com"
KONU="SSH Kara Liste Bildirimi"
LOG_DOSYASI="/var/log/engellenen_ipler.log"

/home/ogr/ip_kara_liste.sh > /tmp/engellenen_ipler_cikti.txt

mail -s "$KONU" "$EPOSTA" < /tmp/engellenen_ipler_cikti.txt

rm /tmp/engellenen_ipler_cikti.txt

