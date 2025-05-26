# SSH Güvenliği ve IP Kara Listesi Projesi

## 1. Giriş
Bu proje, Linux tabanlı bir sunucuda SSH brute-force saldırılarını tespit etmek, bu saldırıları gerçekleştiren IP adreslerini engellemek ve engellemeler hakkında bildirim göndermek amacıyla geliştirilmiştir.

Proje, **Fail2Ban**, **iptables**, **cron** ve bir bildirim betiği kullanarak otomatik bir güvenlik sistemi oluşturmayı hedefler. Bu rapor, projenin kurulum adımlarını, test senaryolarını ve sonuçlarını detaylı bir şekilde açıklamaktadır.

## 2. Projenin Amacı
- SSH bağlantılarına yönelik brute-force saldırılarını tespit etmek ve engellemek.
- Engellenen IP adreslerini izlemek ve bu konuda otomatik bildirimler göndermek.
- Sunucu güvenliğini artırmak için açık kaynak araçlar kullanmak.
- Kurulum ve yapılandırma sürecini dokümante ederek tekrarlanabilir bir sistem sağlamak.

## 3. Kullanılan Araçlar
- **Fail2Ban**
- **iptables**
- **notify_bans.sh**
- **cron**
- **mailutils**
- **Git**
- **Ubuntu 22.04 LTS**

## 4. Kurulum Adımları

### 4.1 Gerekli Yazılımların Kurulumu
sudo apt update
sudo apt install fail2ban iptables mailutils git

### 4.2 Fail2Ban Yapılandırması
sudo nano /etc/fail2ban/jail.local

İçeriği:
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
findtime = 600
action = iptables-multiport[name=sshd, port="22", protocol=tcp]

Fail2Ban servisini başlatmak için:
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

### 4.3 Bildirim Betiği (notify_bans.sh)
nano notify_bans.sh

Betik içeriği:
#!/bin/bash
LOG_FILE="/var/log/fail2ban.log"
EMAIL="senin@email.com"
LAST_CHECK_FILE="/tmp/last_check.txt"

if [ ! -f "$LAST_CHECK_FILE" ]; then
    touch "$LAST_CHECK_FILE"
    echo "0" > "$LAST_CHECK_FILE"
fi

LAST_CHECK=$(cat "$LAST_CHECK_FILE")
NEW_BANS=$(grep "Ban" "$LOG_FILE" | awk -v last="$LAST_CHECK" '$1 > last {print $0}' | grep "sshd")

if [ ! -z "$NEW_BANS" ]; then
    echo "$NEW_BANS" | mail -s "Yeni IP Engellendi" "$EMAIL"
fi

date +%s > "$LAST_CHECK_FILE"

Betiği çalıştırılabilir yapın:
chmod +x notify_bans.sh

### 4.4 Cron Görevi Oluşturma
crontab -e

Açılan dosyaya ekleyin:
*/5 * * * * /path/to/notify_bans.sh

### 4.5 iptables Kontrolü
Fail2Ban tarafından eklenen kuralları kontrol edin:
sudo iptables -L -v -n

Kuralları kalıcı hale getirin:
sudo apt install iptables-persistent
sudo iptables-save > /etc/iptables/rules.v4

## 5. Test Senaryoları

### 5.1 Brute-Force Testi
Başka bir cihazdan SSH ile yanlış giriş denemesi yapıldı:
ssh yanlis_kullanici@<sunucu_ip>

Log kontrolü:
sudo tail -f /var/log/fail2ban.log

Örnek çıktı:
2025-05-12 10:15:23,123 fail2ban.actions [1234]: NOTICE [sshd] Ban 192.168.1.100

### 5.2 iptables Doğrulama
sudo iptables -L -v -n

Örnek çıktı:
Chain f2b-sshd (1 references)
pkts bytes target     prot opt in     out     source               destination
0    0    REJECT     all  --  *      *       192.168.1.100        0.0.0.0/0

### 5.3 Bildirim Testi
./notify_bans.sh

## 6. Sonuçlar

### Başarılar:
- Fail2Ban brute-force saldırılarını başarıyla tespit etti.
- iptables engellenen IP'lerin trafiğini durdurdu.
- Bildirim betiği, engellemeleri e-posta ile haber verdi.
- Tüm sistem başarıyla kuruldu ve test edildi.
