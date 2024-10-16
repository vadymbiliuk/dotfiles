{ ... }: {
  services.yabai = {
    enable = true;
    config = {
      external_bar = "all:39:0";
      layout = "stack";
      auto_balance = "off";

      mouse_modifier = "alt";
      mouse_action2 = "resize";
      mouse_action1 = "move";

      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      window_gap = 12;
    };
    extraConfig = ''
      # bar configuration
      yabai -m signal --add event=window_focused   action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created   action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

      # rules
      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add title="Preferences$"       manage=off
      yabai -m rule --add title="Settings$"          manage=off
      yabai -m rule --add title="1Password$"         manage=off

      # workspace management
      yabai -m space 1  --label web
      yabai -m space 2  --label code
      yabai -m space 3  --label chat
      yabai -m space 4  --label todo
      yabai -m space 5  --label utils

      # assign apps to spaces
      yabai -m rule --add app="Google Chrome" space=web

      yabai -m rule --add app="Kitty" space=code

      yabai -m rule --add app="Discord" space=chat
      yabai -m rule --add app="Telegram" space=chat

      yabai -m rule --add app="Reminder" space=todo
      yabai -m rule --add app="Mail" space=todo
      yabai -m rule --add app="Calendar" space=todo
      yabai -m rule --add app="Obsidian" space=todo

      yabai -m rule --add app="Spotify" space=utils
    '';
  };
}
