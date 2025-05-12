# SSH Guvenlik Projesi Kurulum Dokumantasyonu
## 1. Ubuntu Kurulumu
- VirtualBox ile Ubuntu 22.04 LTS kurun.
- `sudo apt update && sudo apt upgrade` ile sistemi güncelleyin.
## 2. Fail2Ban Kurulumu
- `sudo apt install fail2ban`
- `sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local`
- `jail.local` dosyasını düzenleyiniz.
## 3. Betiklerin Çalıştırılması
- `ip?kara_liste.sh` ve `bildirim_engellenen_ipler.sh` betiklerini çalıştırılabilir yapın: `chmod +x dosya_adi.sh`.
