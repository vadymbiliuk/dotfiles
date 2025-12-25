#!/usr/bin/env bash
hyprctl devices | awk '/main: yes/{found=1} found && /active keymap:/{print $3" "$4; exit}'