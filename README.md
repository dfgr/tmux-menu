# 🚀 TMUX Session Manager (`tmux-menu`)

> **SSH ile sunucuya bağlandığınızda sizi karşılayan, aktif oturumları listeleyen, yeni oturum açıp mevcutlara tek tuşla bağlanmanızı sağlayan hafif ve şık terminal arayüzü (TUI).**

[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![tmux](https://img.shields.io/badge/Dependency-tmux-1BB91F?style=flat-square&logo=tmux&logoColor=white)](https://github.com/tmux/tmux)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-blue?style=flat-square)](https://github.com/dfgr/tmux-menu)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 📸 Arayüz Önizlemesi

```text
┌────────────────────────────────────────────────────────────────┐
│   🚀 ALTUNHOST - TMUX OTURUM YÖNETİCİSİ                        │
├────────────────────────────────────────────────────────────────┤
│  AKTİF OTURUMLAR:
│  [1] bot                (1 pencere ) [Bağlı: 1]
│  [2] dev                (2 pencere ) [Boşta]
│  [3] scanner            (1 pencere ) [Boşta]
├────────────────────────────────────────────────────────────────┤
│ [n] Yeni Oturum Başlat        │ [k] Oturum Kapat (Kill)
│ [r] Oturumu Yeniden Adlandır  │ [b] Normal Bash Terminali
│ [q] Çıkış (SSH Kapat)         │ [Enter] Hızlı Bağlan
└────────────────────────────────────────────────────────────────┘
👉 Seçiminiz [1-3 / n / k / r / b / q] (Varsayılan: 1): 
```

---

## ✨ Özellikler

* 📱 **Duyarlı & Mobil Uyumlu:** Telefon (Termius, JuiceSSH) ve PC geniş ekranlarına göre pencere boyutunu (`40` - `66` sütun) otomatik ölçekler.
* ⚡ **Sıfır Ekstra Bağımlılık & Anında Açılış:** Sadece standart **Bash** ve **tmux** kullanır. `~/.hushlogin` ile Ubuntu MOTD/karşılama loglarını atlayarak SSH bağlandığı anda beklemesiz açılır.
* 📜 **Varsayılan Scroll & Fare Desteği:** Tmux oturumlarında fare ile kaydırma (`set -g mouse on`) otomatik olarak aktiftir. Metin kopyalamak için `Shift` tuşuna basılı tutarak fareyle seçebilirsiniz.
* 🔒 **SSH & Otomasyon Dostu:** SCP, SFTP, rsync, Ansible veya `ssh user@host "command"` gibi interaktif olmayan çağrıları **kesinlikle bozmaz** (TTY kontrolü yapar).
* 🔄 **Canlı Durum Rozetleri:** Oturumlara başka bir istemcinin bağlı olup olmadığını (`[Bağlı: 1]`, `[Boşta]`) ve pencere sayısını anlık gösterir.
* ⌨️ **Hızlı Kısayollar:** Ana seçim ekranında `Ctrl + C` veya `q` ile SSH bağlantısını anında kapatma, tmux içindeyken `d` veya `detach` yazarak kolayca menüye dönme.

---

## 📦 Kurulum

### 1. Tek Komutla Hızlı Kurulum

Sunucunuzda veya yerel makinenizde şu komutu çalıştırmanız yeterlidir:

```bash
git clone https://github.com/dfgr/tmux-menu.git ~/.tmux-menu && ~/.tmux-menu/install.sh
```

*(Eğer `sudo` yetkiniz varsa `/usr/local/bin/tmux-menu` altına kopyalanır, yoksa otomatik olarak `~/.local/bin/tmux-menu` altına yüklenir).*

---

### 2. Manuel Kurulum

1. Depoyu klonlayın:
   ```bash
   git clone https://github.com/dfgr/tmux-menu.git
   cd tmux-menu
   ```

2. Betiğe çalıştırma izni verip sistem dizinine kopyalayın:
   ```bash
   sudo cp bin/tmux-menu /usr/local/bin/tmux-menu
   sudo chmod +x /usr/local/bin/tmux-menu
   ```

3. `~/.bashrc` veya `~/.zshrc` dosyanızın en altına şu satırları ekleyin:
   ```bash
   # TMUX Session Manager Otomatik Başlatıcı
   alias menu="/usr/local/bin/tmux-menu"
   alias tm="/usr/local/bin/tmux-menu"

   if [[ $- == *i* ]] && [ -t 0 ] && [ -t 1 ] && [ -z "$TMUX" ]; then
       /usr/local/bin/tmux-menu
   fi

   if [ -n "$TMUX" ]; then
       alias detach="tmux detach"
       alias d="tmux detach"
   fi
   ```

4. Değişiklikleri uygulayın:
   ```bash
   source ~/.bashrc
   ```

---

## 🎮 Kullanım ve Kısayollar

| Tuş / Seçim | Açıklama |
| :--- | :--- |
| **`[1-9]` / `[Enter]`** | İlgili numaradaki aktif tmux oturumuna anında bağlanır (`tmux attach`). |
| **`[n]`** | Yeni oturum başlatır. Oturuma isim verebilir veya `Enter` ile otomatik isim alabilirsiniz. |
| **`[k]`** | Seçtiğiniz oturumu onay alarak arka planda tamamen sonlandırır (`kill-session`). |
| **`[r]`** | Mevcut bir oturumun adını günceller (`rename-session`). |
| **`[b]`** | Menüyü geçerek standart Bash terminaline düşer. |
| **`[q]` / `Ctrl + C`** | Ana seçim ekranındayken SSH bağlantısını sonlandırıp güvenle çıkar. |

### Fare ve Metin Seçimi
* **Kaydırma (Scroll):** Fare tekerleği ile doğrudan yukarı/aşağı kaydırabilirsiniz.
* **Metin Kopyalama:** `Shift` tuşuna basılı tutarak fareyle metni seçtiğinizde terminalin yerel panosuna kopyalayabilirsiniz (macOS'ta `Fn` veya `Option`).

### Tmux ve Terminal İçi Komutlar
* **`menu`** veya **`tm`** : Bash terminalindeyken oturum menüsünü tekrar açar.
* **`d`** veya **`detach`** : Tmux oturumu içindeyken oturumu kapatmadan arka plana atıp menüye döner.

---

## ⚙️ Özelleştirme

Menü başlığını veya varsayılan çalışma dizinini `~/.bashrc` dosyanızda ortam değişkeni olarak tanımlayabilirsiniz:

```bash
export TMUX_MENU_TITLE="  ⚡ MY CLOUD VPS - SESSION HUB"
export TMUX_DEFAULT_DIR="/home/yusuf/projects"
```

---

## 🗑️ Kaldırma

Uygulamayı ve `.bashrc` kayıtlarını tamamen kaldırmak için:

```bash
~/.tmux-menu/uninstall.sh
# veya klonladığınız dizinden:
./uninstall.sh
```

---

## 📄 Lisans

Bu proje **MIT** lisansı ile lisanslanmıştır.
