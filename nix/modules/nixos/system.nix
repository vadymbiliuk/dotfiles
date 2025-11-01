{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
  };

  console.keyMap = "us";

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "BerkeleyMonoMinazuki Nerd Font" ];
        sansSerif = [ "BerkeleyMonoMinazuki Nerd Font" ];
        monospace = [ "BerkeleyMonoMinazuki Nerd Font Mono" ];
      };
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "ghostty";
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  system.stateVersion = "24.11";
}
