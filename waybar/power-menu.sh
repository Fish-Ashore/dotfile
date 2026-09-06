#!/usr/bin/env bash
set -euo pipefail

export PATH="/run/current-system/sw/bin:/etc/profiles/per-user/${USER:-$(id -un)}/bin:$HOME/.nix-profile/bin:$PATH"

FONT="0xProto Nerd Font:size=16"

COMMON=(
  --font "$FONT"
  --width 30
  --horizontal-pad 44
  --vertical-pad 16
  --inner-pad 10
  --border-width 1
  --border-radius 10
  --selection-radius 6
  --background 0c0c14eb
  --text-color e2e8f0ff
  --prompt-color 64748bff
  --match-color 22d3eeff
  --selection-color 22d3ee24
  --selection-text-color 67e8f9ff
  --selection-match-color 67e8f9ff
  --border-color 22d3ee66
)

run() {
  fuzzel --dmenu "${COMMON[@]}" --lines "$1" --prompt "$2"
}

confirm() {
  local action="$1"
  printf 'Confirm\nCancel\n' |
    fuzzel --dmenu "${COMMON[@]}" --lines 2 --prompt "$action  " --select Cancel |
    grep -qx 'Confirm'
}

choice="$(printf '\uf023 Lock\n\uf186 Suspend\n\uf2f9 Reboot\n\uf011 Shutdown\n' | run 4 '  ')"

case "$choice" in
  *Lock)
    hyprlock
    ;;
  *Suspend)
    systemctl suspend
    ;;
  *Reboot)
    if confirm Reboot; then
      systemctl reboot
    fi
    ;;
  *Shutdown)
    if confirm Shutdown; then
      systemctl poweroff
    fi
    ;;
  *)
    notify-send "Power" "Unknown option: $choice"
    ;;
esac
