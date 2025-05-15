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
