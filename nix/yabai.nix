{ ... }: {
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";

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
      yabai -m mouse_drop_action swap

      yabai -m rule --add app="^System Settings$"    manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add title="Preferences$"       manage=off
      yabai -m rule --add title="Settings$"          manage=off
      yabai -m rule --add title="1Password$"         manage=off
    '';
  };
}
