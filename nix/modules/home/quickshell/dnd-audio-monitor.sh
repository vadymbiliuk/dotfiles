#!/usr/bin/env bash

# Monitor and mute notification sounds while DND is active
# This script runs continuously and monitors for new audio streams

DND_CONFIG="$HOME/.config/quickshell/dnd-config.json"

check_dnd_status() {
    if [ -f "$DND_CONFIG" ]; then
        grep -q '"dndEnabled":true' "$DND_CONFIG" 2>/dev/null
        return $?
    fi
    return 1
}

get_dnd_profile() {
    if [ -f "$DND_CONFIG" ]; then
        if grep -q '"dndProfile":"work"' "$DND_CONFIG" 2>/dev/null; then
            echo "work"
        else
            echo "silent"
        fi
    else
        echo "silent"
    fi
}

mute_notification_streams() {
    if ! command -v pactl &> /dev/null; then
        return
    fi
    
    for stream in $(pactl list sink-inputs short | cut -f1); do
        # Get the application name and media role for this stream
        stream_info=$(pactl list sink-inputs | grep -A 20 "Sink Input #$stream")
        app_name=$(echo "$stream_info" | grep "application.name" | cut -d'"' -f2)
        media_role=$(echo "$stream_info" | grep "media.role" | cut -d'"' -f2)
        
        # Check if this stream should be muted
        should_mute=false
        profile=$(get_dnd_profile)
        
        if check_dnd_status; then
            if [ "$profile" = "work" ]; then
                # In work mode, don't mute Slack
                if [[ "$app_name" =~ (telegram|Telegram|TelegramDesktop|discord|Discord|teams|Teams|element|Element|signal|Signal) ]] || \
                   [[ "$media_role" =~ (event|notification|phone|alert) && ! "$app_name" =~ (slack|Slack) ]]; then
                    should_mute=true
                fi
            else
                # In silent mode, mute everything
                if [[ "$app_name" =~ (telegram|Telegram|TelegramDesktop|discord|Discord|slack|Slack|teams|Teams|element|Element|signal|Signal) ]] || \
                   [[ "$media_role" =~ (event|notification|phone|alert) ]]; then
                    should_mute=true
                fi
            fi
        fi
        
        if [ "$should_mute" = true ]; then
            pactl set-sink-input-mute "$stream" 1 2>/dev/null
        else
            pactl set-sink-input-mute "$stream" 0 2>/dev/null
        fi
    done
}

# Monitor for new streams
if command -v pactl &> /dev/null; then
    # Initial check
    mute_notification_streams
    
    # Monitor for new sink inputs
    pactl subscribe 2>/dev/null | while read -r line; do
        if [[ "$line" =~ "sink-input" ]]; then
            sleep 0.1  # Small delay to let the stream initialize
            mute_notification_streams
        fi
    done
else
    echo "PulseAudio/PipeWire not found. Cannot monitor audio streams."
    exit 1
fi