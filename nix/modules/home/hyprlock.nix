{ config, pkgs, lib, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = true;
        no_fade_out = true;
        ignore_empty_input = false;
        immediate_render = true;
        pam_module = "hyprlock";
      };

      background = [
        {
          monitor = "";
          path = "$HOME/.config/wallpaper.jpg";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "250, 50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.35;
          dots_center = true;
          outer_color = "rgba(128, 128, 128, 0.8)";
          inner_color = "rgba(64, 64, 64, 0.8)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          font_family = "BerkeleyMonoMinazuki Nerd Font";
          placeholder_text = ''<span foreground="##cccccc">Enter Password</span>'';
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
          check_color = "rgb(128, 128, 128)";
          fail_color = "rgb(64, 64, 64)";
          fail_text = "$FAIL ($ATTEMPTS)";
          fail_transition = 300;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(192, 192, 192, 0.9)";
          font_size = 120;
          font_family = "BerkeleyMonoMinazuki Nerd Font";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(160, 160, 160, 0.7)";
          font_size = 24;
          font_family = "BerkeleyMonoMinazuki Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(180, 180, 180, 0.8)";
          font_size = 18;
          font_family = "BerkeleyMonoMinazuki Nerd Font";
          position = "0, -50";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Type password to unlock";
          color = "rgba(128, 128, 128, 0.5)";
          font_size = 12;
          font_family = "BerkeleyMonoMinazuki Nerd Font";
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}