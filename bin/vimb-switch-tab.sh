#!/usr/bin/env bash

################################################################################
# Focus a vimb window/tab based on its title.
set -e
set -u

################################################################################
if [ $# -eq 1 ] && [ -n "$1" ]; then
  if xprop -id "$1" WM_CLASS | grep -Fiv '"vimb"'; then
    # vimb is running in xembed mode, delegate to another script.
    exec rofi-tabbed.sh "$1"
  fi
fi

################################################################################
list_vimb_windows() {
  readarray -t ids < <(
    wmctrl -lx | awk '$3 == "vimb.Vimb" {print $1}'
  )

  for id in "${ids[@]}"; do
    title=$(xdotool getwindowname "$id" | sed 's/[^[:alnum:]]+/_/g')
    printf '["%s (%s)"]="%s"\n' "$title" "$id" "$id"
  done
}

################################################################################
declare -A windows="( $(list_vimb_windows) )"

answer=$(rofi -dmenu -i -p "vimb" -no-custom < <(
  for title in "${!windows[@]}"; do
    echo "$title"
  done
))

wmctrl -a "${windows["$answer"]}" -i
