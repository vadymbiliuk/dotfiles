{ pkgs, inputs, ... }:

let
  theme = import ../themes/monochrome.nix;
  c = theme.colors.editor;
  l = theme.layout.terminal;
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  kitty-scrollback = unstable.vimPlugins.kitty-scrollback-nvim;
in
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

      disable_ligatures = "never";
      modify_font = "underline_position +2";

      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_trail = 0;
      cursor_trail_start_threshold = 20;

      window_padding_width = l.paddingWidth;
      window_margin_width = l.marginWidth;
      hide_window_decorations = "titlebar-only";
      confirm_os_window_close = 0;
      enabled_layouts = "splits,stack";

      wheel_scroll_multiplier = "3.0";
      touch_scroll_multiplier = "3.0";
      scrollback_lines = 100000;

      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      background_opacity = l.backgroundOpacity;
      background_blur = l.backgroundBlur;

      macos_option_as_alt = "yes";
      macos_colorspace = "displayp3";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "background";

      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
      clipboard_control = "write-clipboard write-primary read-clipboard read-primary no-append";

      editor = "nvim";

      url_style = "curly";
      open_url_with = "default";

      foreground = c.foreground;
      background = c.background;
      cursor = c.cursor;
      cursor_text_color = c.cursorText;
      selection_foreground = "none";
      selection_background = c.selectionBg;
      url_color = c.urlColor;

      color0 = c.black;
      color8 = c.brightBlack;
      color1 = c.red;
      color9 = c.red;
      color2 = c.green;
      color10 = c.green;
      color3 = c.yellow;
      color11 = c.yellow;
      color4 = c.blue;
      color12 = c.blue;
      color5 = c.magenta;
      color13 = c.magenta;
      color6 = c.cyan;
      color14 = c.cyan;
      color7 = c.white;
      color15 = c.white;
    };

    keybindings = {
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

      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";

      "super+1" = "goto_tab 1";
      "super+2" = "goto_tab 2";
      "super+3" = "goto_tab 3";
      "super+4" = "goto_tab 4";
      "super+5" = "goto_tab 5";
      "super+6" = "goto_tab 6";
      "super+7" = "goto_tab 7";
      "super+8" = "goto_tab 8";
      "super+9" = "goto_tab 9";

      "cmd+f" = "kitten ${kitty-scrollback}/python/kitty_scrollback_nvim.py";
      "ctrl+shift+f" = "kitten ${kitty-scrollback}/python/kitty_scrollback_nvim.py";

      "cmd+c" = "copy_to_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "cmd+с" = "copy_to_clipboard";
      "cmd+м" = "paste_from_clipboard";

      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+с" = "copy_to_clipboard";
      "ctrl+shift+м" = "paste_from_clipboard";

      "cmd+plus" = "change_font_size all +2.0";
      "cmd+minus" = "change_font_size all -2.0";
      "cmd+0" = "change_font_size all 0";

      "super+plus" = "change_font_size all +2.0";
      "super+minus" = "change_font_size all -2.0";
      "super+0" = "change_font_size all 0";

      "ctrl+cmd+," = "load_config_file";
      "ctrl+super+," = "load_config_file";

      "kitty_mod+backslash" = "launch --location=vsplit --cwd=current";
      "kitty_mod+s" = "launch --location=hsplit --cwd=current";

      "kitty_mod+h" = "neighboring_window left";
      "kitty_mod+j" = "neighboring_window bottom";
      "kitty_mod+k" = "neighboring_window top";
      "kitty_mod+l" = "neighboring_window right";
    };
  };
}
