# SSH Güvenliği ve IP Kara Listesi Projesi

## 1. Proje Amacı
Bu proje, SSH sunucusuna yapılan brute-force saldırılarını tespit ederek IP’leri otomatik olarak engellemeyi ve sunucu güvenliğini artırmayı amaçlamaktadır. VirtualBox üzerinde bir Ubuntu Server kullanılarak test edilmiştir. Fail2Ban ve iptables ile IP kara listesi oluşturulmuş, engellenen IP’ler için bildirim mekanizması uygulanmıştır.

## 2. Kullanılan Araçlar
- **OpenSSH**: SSH sunucusu kurulum ve yönetimi için.
- **Fail2Ban**: Brute-force saldırılarını tespit edip IP’leri engellemek için.
- **iptables**: IP kara listesi oluşturmak ve yönetmek için.
- **VirtualBox**: Yerel test ortamı olarak sanal makine oluşturmak için.
- **Git**: Kaynak kod yönetimi ve GitHub’a yükleme.
- **Bash Betikleri**: IP engelleme ve bildirim otomasyonu için.
- **OBS Studio**: Video kaydı için.

## 3. Ortam Kurulum Adımları
### 3.1. VirtualBox Ortamı Kurulumu
- **VirtualBox Kurulumu**:
  - VirtualBox, [resmi sitesinden](https://www.virtualbox.org/) indirildi ve kuruldu.
- **Sanal Makine Oluşturma**:
  - Ubuntu Server 22.04 ISO dosyası indirildi.
  - VirtualBox’ta yeni bir sanal makine oluşturuldu:
    - Ad: `ssh-security-vm`
    - RAM: 2 GB
    - Disk: 20 GB
    - Ağ: NAT veya Bridged Adapter (yerel ağ testi için).
  - Ubuntu Server kurulumu tamamlandı, kullanıcı adı `ubuntu` ve parola belirlendi.
- **SSH Erişimi**:
  - Sanal makinenin IP adresi kontrol edildi: `ip addr show`.
  - Yerel makineden SSH bağlantısı: `ssh ubuntu@<vm_ip>`.

### 3.2. Yazılım Kurulumu
- **OpenSSH Kurulumu**:
  ```bash
  sudo apt update
  sudo apt install openssh-server
  sudo systemctl enable ssh
  sudo systemctl start ssh

## Fail2Ban Kurulumu:

    sudo apt install fail2ban

  /etc/fail2ban/jail.local yapılandırması:
  ini

  -[sshd]
  -enabled = true
  -port = 22
  -maxretry = 3
  -bantime = 600
  -findtime = 600

## Servis başlatma:

    sudo systemctl enable fail2ban
    sudo systemctl start fail2ban

## iptables Kurulumu:

    sudo iptables -N BLACKLIST
    sudo iptables -A BLACKLIST -j DROP
    sudo iptables -A INPUT -j BLACKLIST
    sudo iptables -A BLACKLIST -s <blacklist_ip> -j DROP
    sudo apt install iptables-persistent
    sudo dpkg-reconfigure iptables-persistent

### 3.3. Bash Betikleri
  ip_kara_liste.sh: IP’leri iptables ile engeller.
  

#!/bin/bash
#ip_kara_liste.sh

BLACKLIST_IP=$1
if [ -z "$BLACKLIST_IP" ]; then
    echo "Hata: Engellenecek IP adresini belirtin."
    exit 1
fi
sudo iptables -A BLACKLIST -s "$BLACKLIST_IP" -j DROP
echo "IP $BLACKLIST_IP engellendi."

bildirim_engellenen_ipler.sh: Engellenen IP’ler için e-posta bildirimi gönderir.
bash

#!/bin/bash
# bildirim_engellenen_ipler.sh
    BLACKLIST_IP=$1
    RECIPIENT="ornek@email.com"
    SUBJECT="IP Engelleme Bildirimi"
    BODY="IP $BLACKLIST_IP SSH brute-force nedeniyle engellendi."
    echo "$BODY" | mail -s "$SUBJECT" "$RECIPIENT"

## Cron Job: Bildirim betiğini her 5 dakikada çalıştırmak için:
    crontab -e
    */5 * * * * /path/to/bildirim_engellenen_ipler.sh <blacklist_ip>

### 4. Test ve Sonuçlar
  -Brute-Force Testi: Yerel makineden ssh invalid-user@<vm_ip> ile 3 başarısız giriş denendi.

  -Fail2Ban Logları: /var/log/fail2ban.log incelenerek IP engelleme doğrulandı.

  -iptables Çıktısı: sudo iptables -L ile engellenen IP’ler kontrol edildi.

  -Bildirim Testi: E-posta bildirimi alındı.

  -Sonuç: VirtualBox ortamında SSH güvenliği sağlandı, IP’ler başarıyla engellendi.


### 5. GitHub Reposu
  -Proje dosyaları: https://github.com/KemalAlihan/ssh-guvenlik-projesi.git

  
### 7. Sonuç
  -Proje, VirtualBox üzerinde Ubuntu Server kullanılarak SSH güvenliğini artırmak için Fail2Ban ve iptables ile IP kara listesi oluşturmayı başardı. Bildirim      sistemi, engellemelerin anlık takibini mümkün kıldı.

#### **Raporu GitHub’a Yükleme**
## 1. **Dosyaları Hazırlayın**:
   - `README.md`: Yukarıdaki içeriği kopyalayın ve düzenleyin (GitHub repo linki, ekran görüntüleri).
   - `ip_kara_liste.sh` ve `bildirim_engellenen_ipler.sh`: Yukarıdaki betikleri oluşturun.
   - `jail.local`: Fail2Ban yapılandırma dosyasını kopyalayın.

## 2. **Git Komutları**:
    sudo apt install git
    git init
    git add README.md ip_kara_liste.sh bildirim_engellenen_ipler.sh jail.local screenshots/
    git commit -m "Add project report and files"
    git remote add origin https://github.com/<kullanici_adi>/ssh-guvenlik-projesi.git
    git push -u origin main

