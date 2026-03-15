{ pkgs, ... }:

{
  xdg.configFile."kitty/kitty.app.png".source = ./kitty.app.png;

  programs.kitty = {
    enable = true;
    font = {
      name = "BerkeleyMonoMinazuki Nerd Font Mono";
      size = if pkgs.stdenv.isDarwin then 22 else 18;
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      enable_audio_bell = "no";

      # Font tweaks
      disable_ligatures = "never";
      modify_font = "underline_position +2";

      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_trail = 0;
      cursor_trail_start_threshold = 20;

      # Window
      window_padding_width = 14;
      window_margin_width = "2 0 0 2";
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;
      enabled_layouts = "splits,stack";

      # Scrolling
      wheel_scroll_multiplier = "3.0";
      touch_scroll_multiplier = "3.0";
      scrollback_lines = 100000;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      # Appearance
      background_opacity = "0.8";
      background_blur = 64;

      # macOS
      macos_option_as_alt = "yes";
      macos_colorspace = "displayp3";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "background";

      # Shell & remote control
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary no-append";

      # Editor
      editor = "nvim";

      # URL
      url_style = "curly";
      open_url_with = "default";

      # Lackluster theme
      foreground = "#DEEEED";
      background = "#0A0A0A";
      cursor = "#DEEEED";
      cursor_text_color = "#080808";
      selection_foreground = "none";
      selection_background = "#7A7A7A";
      url_color = "#D7007D";

      color0 = "#080808";
      color8 = "#444444";
      color1 = "#D70000";
      color9 = "#D70000";
      color2 = "#789978";
      color10 = "#789978";
      color3 = "#ffAA88";
      color11 = "#ffAA88";
      color4 = "#7788AA";
      color12 = "#7788AA";
      color5 = "#D7007D";
      color13 = "#D7007D";
      color6 = "#708090";
      color14 = "#708090";
      color7 = "#DEEEED";
      color15 = "#DEEEED";
    };

    keybindings = {
      # Disable defaults
      "kitty_mod+u" = "no_op";
      "cmd+r" = "no_op";
      "cmd+k" = "no_op";
      "cmd+n" = "no_op";
      "cmd+h" = "no_op";
      "cmd+m" = "no_op";
      "cmd+opt+s" = "no_op";
      "opt+cmd+h" = "no_op";
      "cmd+ctrl+l" = "no_op";
      "cmd+enter" = "no_op";
      "kitty_mod+enter" = "no_op";

      # Switch windows (tabs) - macOS
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";

      # Switch windows (tabs) - Linux
      "super+1" = "goto_tab 1";
      "super+2" = "goto_tab 2";
      "super+3" = "goto_tab 3";
      "super+4" = "goto_tab 4";
      "super+5" = "goto_tab 5";
      "super+6" = "goto_tab 6";
      "super+7" = "goto_tab 7";
      "super+8" = "goto_tab 8";
      "super+9" = "goto_tab 9";

      # Search scrollback
      "cmd+f" = "show_scrollback";
      "super+f" = "show_scrollback";

      # Copy/Paste - macOS (layout independent)
      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "cmd+с" = "copy_to_clipboard";
      "cmd+м" = "paste_from_clipboard";

      # Copy/Paste - Linux (layout independent)
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+с" = "copy_to_clipboard";
      "ctrl+shift+м" = "paste_from_clipboard";

      # Font size - macOS
      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";

      # Font size - Linux
      "super+plus" = "change_font_size all +2.0";
      "super+minus" = "change_font_size all -2.0";
      "super+0" = "change_font_size all 0";

      # Config reload
      "ctrl+cmd+," = "load_config_file";
      "ctrl+super+," = "load_config_file";

      # Splits
      "kitty_mod+v" = "launch --location=vsplit --cwd=current";
      "kitty_mod+s" = "launch --location=hsplit --cwd=current";

      # Navigate splits
      "kitty_mod+h" = "neighboring_window left";
      "kitty_mod+j" = "neighboring_window bottom";
      "kitty_mod+k" = "neighboring_window top";
      "kitty_mod+l" = "neighboring_window right";
    };
  };
}
