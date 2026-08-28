#!/usr/bin/env bash
set -e

# ==============================================================================
# TMUX Session Manager Uninstaller
# ==============================================================================

BOLD="\033[1m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${YELLOW}${BOLD}» TMUX Session Manager kaldırılıyor...${RESET}"

# 1. Binary dosyalarını kaldır
if [ -f "/usr/local/bin/tmux-menu" ]; then
    if [ "$EUID" -eq 0 ]; then
        rm -f "/usr/local/bin/tmux-menu"
    elif command -v sudo >/dev/null 2>&1; then
        sudo rm -f "/usr/local/bin/tmux-menu"
    fi
fi

if [ -f "$HOME/.local/bin/tmux-menu" ]; then
    rm -f "$HOME/.local/bin/tmux-menu"
fi

# 2. RC dosyalarından bloğu temizle
for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC_FILE" ]; then
        if grep -q "TMUX Session Manager" "$RC_FILE"; then
            sed -i '/# --- TMUX Session Manager (tmux-menu) ---/,/# --- End TMUX Session Manager ---/d' "$RC_FILE"
            echo -e "${GREEN}✓ ${RC_FILE} dosyasından yapılandırma temizlendi.${RESET}"
        fi
    fi
done

# 3. ~/.tmux.conf dosyasından bloğu temizle
if [ -f "$HOME/.tmux.conf" ]; then
    if grep -q "TMUX Session Manager (Fare ve Scroll Desteği)" "$HOME/.tmux.conf"; then
        sed -i '/# --- TMUX Session Manager (Fare ve Scroll Desteği) ---/,/# ---------------------------------------------------/d' "$HOME/.tmux.conf"
        echo -e "${GREEN}✓ ~/.tmux.conf dosyasından fare ayarları temizlendi.${RESET}"
    fi
fi

echo -e "${GREEN}${BOLD}✓ TMUX Session Manager başarıyla kaldırıldı.${RESET}\n"
