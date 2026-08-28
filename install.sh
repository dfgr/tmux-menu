#!/usr/bin/env bash
set -e

# ==============================================================================
# TMUX Session Manager Installer
# ==============================================================================

BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}======================================================${RESET}"
echo -e "${CYAN}${BOLD} 🚀 TMUX Session Manager Kurulum Sihirbazı            ${RESET}"
echo -e "${CYAN}${BOLD}======================================================${RESET}"

# 1. Tmux kurulu mu kontrol et
if ! command -v tmux >/dev/null 2>&1; then
    echo -e "${YELLOW}» tmux bulunamadı, kuruluyor...${RESET}"
    if [ "$EUID" -eq 0 ]; then
        if command -v apt-get >/dev/null 2>&1; then
            apt-get update -qq && apt-get install -y -qq tmux
        elif command -v yum >/dev/null 2>&1; then
            yum install -y -q tmux
        elif command -v pacman >/dev/null 2>&1; then
            pacman -Sy --noconfirm tmux
        fi
    elif command -v sudo >/dev/null 2>&1; then
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update -qq && sudo apt-get install -y -qq tmux
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y -q tmux
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy --noconfirm tmux
        fi
    else
        echo -e "${RED}Hata: tmux paketi kurulamadı. Lütfen manuel olarak tmux kurun.${RESET}"
        exit 1
    fi
fi
echo -e "${GREEN}✓ tmux kurulu ve hazır.${RESET}"

# 2. Betiği hedef dizine kopyala
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_BIN="$SCRIPT_DIR/bin/tmux-menu"

if [ "$EUID" -eq 0 ] || sudo -n true 2>/dev/null; then
    TARGET_BIN="/usr/local/bin/tmux-menu"
    if [ "$EUID" -eq 0 ]; then
        cp "$SOURCE_BIN" "$TARGET_BIN"
        chmod +x "$TARGET_BIN"
    else
        sudo cp "$SOURCE_BIN" "$TARGET_BIN"
        sudo chmod +x "$TARGET_BIN"
    fi
else
    TARGET_DIR="$HOME/.local/bin"
    mkdir -p "$TARGET_DIR"
    TARGET_BIN="$TARGET_DIR/tmux-menu"
    cp "$SOURCE_BIN" "$TARGET_BIN"
    chmod +x "$TARGET_BIN"
fi
echo -e "${GREEN}✓ tmux-menu binary dosyası yerleştirildi: ${TARGET_BIN}${RESET}"

# 3. Shell yapılandırma dosyalarını güncelle
RC_BLOCK=$(cat << 'EOF'

# --- TMUX Session Manager (tmux-menu) ---
alias menu="/usr/local/bin/tmux-menu"
alias tm="/usr/local/bin/tmux-menu"

# Interaktif SSH ve Terminal girişinde otomatik başlat
if [[ $- == *i* ]] && [ -t 0 ] && [ -t 1 ] && [ -z "$TMUX" ]; then
    if [ -x "/usr/local/bin/tmux-menu" ]; then
        /usr/local/bin/tmux-menu
    elif [ -x "$HOME/.local/bin/tmux-menu" ]; then
        "$HOME/.local/bin/tmux-menu"
    fi
fi

# Tmux içindeyken kolay ayrılma kısayolları
if [ -n "$TMUX" ]; then
    alias detach="tmux detach"
    alias d="tmux detach"
fi
# --- End TMUX Session Manager ---
EOF
)

for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC_FILE" ]; then
        if grep -q "TMUX Session Manager" "$RC_FILE"; then
            echo -e "${YELLOW}» ${RC_FILE} içinde zaten yapılandırma mevcut, atlandı.${RESET}"
        else
            echo "$RC_BLOCK" >> "$RC_FILE"
            echo -e "${GREEN}✓ ${RC_FILE} dosyasına otomatik başlatıcı eklendi.${RESET}"
        fi
    fi
done

# 4. ~/.tmux.conf dosyasında fare ve kaydırma (scroll) desteğini etkinleştir
TMUX_CONF="$HOME/.tmux.conf"
if [ ! -f "$TMUX_CONF" ]; then
    cat << 'EOF' > "$TMUX_CONF"
# TMUX Varsayılan Ayarları (tmux-menu)
set -g mouse on
EOF
    echo -e "${GREEN}✓ ${TMUX_CONF} oluşturuldu ve varsayılan fare/scroll desteği (set -g mouse on) etkinleştirildi.${RESET}"
elif ! grep -q "mouse on" "$TMUX_CONF"; then
    cat << 'EOF' >> "$TMUX_CONF"

# --- TMUX Session Manager (Fare ve Scroll Desteği) ---
set -g mouse on
# ---------------------------------------------------
EOF
    echo -e "${GREEN}✓ ${TMUX_CONF} dosyasına varsayılan fare/scroll desteği (set -g mouse on) eklendi.${RESET}"
else
    echo -e "${GREEN}✓ ${TMUX_CONF} içinde fare/scroll desteği zaten aktif.${RESET}"
fi

# Çalışan tmux sunucusu varsa ayarları anında uygula
if command -v tmux >/dev/null 2>&1; then
    tmux set -g mouse on 2>/dev/null || true
fi

# 5. SSH girişini hızlandır ve Ubuntu karşılama mesajlarını (MOTD) sessize al
if [ ! -f "$HOME/.hushlogin" ]; then
    touch "$HOME/.hushlogin"
    echo -e "${GREEN}✓ ${HOME}/.hushlogin oluşturuldu (SSH girişleri hızlandırıldı, MOTD gizlendi).${RESET}"
fi

echo -e "\n${CYAN}${BOLD}======================================================${RESET}"
echo -e "${GREEN}${BOLD} 🎉 Kurulum başarıyla tamamlandı!                      ${RESET}"
echo -e "${CYAN}${BOLD}======================================================${RESET}"
echo -e "Menüyü hemen test etmek için terminalde ${YELLOW}${BOLD}menu${RESET} veya ${YELLOW}${BOLD}tm${RESET} yazabilirsiniz."
echo -e "SSH ile bir sonraki girişinizde menü doğrudan ve beklemesiz olarak açılacaktır.\n"
