#!/usr/bin/env bash

# Toggle notification sounds based on DND state
# Usage: ./toggle-notification-sounds.sh [on|off]

STATE="${1:-on}"

if [ "$STATE" = "off" ]; then
    # Mute notification sounds
    # Try different approaches depending on what's available
    
    # Option 1: If using PipeWire/PulseAudio, mute event sounds
    if command -v pactl &> /dev/null; then
        # Mute system sounds/event sounds
        pactl set-sink-mute @DEFAULT_SINK@ 0  # Don't mute main audio
        
        # Mute all notification-related streams including Telegram
        for stream in $(pactl list sink-inputs short | cut -f1); do
            # Get the application name for this stream
            app_name=$(pactl list sink-inputs | grep -A 20 "Sink Input #$stream" | grep "application.name" | cut -d'"' -f2)
            media_role=$(pactl list sink-inputs | grep -A 20 "Sink Input #$stream" | grep "media.role" | cut -d'"' -f2)
            
            # Mute if it's a notification sound or from known chat apps
            if [[ "$app_name" =~ (telegram|Telegram|discord|Discord|slack|Slack|teams|Teams) ]] || \
               [[ "$media_role" =~ (event|notification|phone|alert) ]]; then
                pactl set-sink-input-mute "$stream" 1
            fi
        done
    fi
    
    # Option 2: Use gsettings to disable event sounds (GNOME/GTK apps)
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.sound event-sounds false 2>/dev/null || true
    fi
    
    # Option 3: Mute specific notification daemon if using dunst
    if command -v dunstctl &> /dev/null; then
        dunstctl set-paused true 2>/dev/null || true
    fi
    
else
    # Enable notification sounds
    
    # Re-enable PulseAudio event sounds
    if command -v pactl &> /dev/null; then
        for stream in $(pactl list sink-inputs short | cut -f1); do
            # Get the application name for this stream
            app_name=$(pactl list sink-inputs | grep -A 20 "Sink Input #$stream" | grep "application.name" | cut -d'"' -f2)
            media_role=$(pactl list sink-inputs | grep -A 20 "Sink Input #$stream" | grep "media.role" | cut -d'"' -f2)
            
            # Unmute if it's a notification sound or from known chat apps
            if [[ "$app_name" =~ (telegram|Telegram|discord|Discord|slack|Slack|teams|Teams) ]] || \
               [[ "$media_role" =~ (event|notification|phone|alert) ]]; then
                pactl set-sink-input-mute "$stream" 0
            fi
        done
    fi
    
    # Re-enable GNOME event sounds
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.sound event-sounds true 2>/dev/null || true
    fi
    
    # Resume dunst notifications
    if command -v dunstctl &> /dev/null; then
        dunstctl set-paused false 2>/dev/null || true
    fi
fi