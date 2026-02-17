#!/usr/bin/env bash

state_file="/tmp/quickshell-layout-index"
output_file="/tmp/quickshell-current-layout"
kb_data=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true)')
layouts=$(echo "$kb_data" | jq -r '.layout')
current_keymap=$(echo "$kb_data" | jq -r '.active_keymap')

IFS=',' read -ra layout_arr <<< "$layouts"

if [[ ! -f "$state_file" ]]; then
    echo "0" > "$state_file"
fi

current_index=$(cat "$state_file")
last_keymap_file="/tmp/quickshell-last-keymap"

if [[ -f "$last_keymap_file" ]]; then
    last_keymap=$(cat "$last_keymap_file")
    if [[ "$current_keymap" != "$last_keymap" ]]; then
        current_index=$(( (current_index + 1) % ${#layout_arr[@]} ))
        echo "$current_index" > "$state_file"
    fi
fi

echo "$current_keymap" > "$last_keymap_file"
current_layout="${layout_arr[$current_index]}"
echo "$current_layout" > "$output_file"
echo "$current_layout"