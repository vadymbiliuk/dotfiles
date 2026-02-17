{
  config,
  lib,
  pkgs,
  ...
}:

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
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
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

  security.sudo = {
    wheelNeedsPassword = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults        timestamp_timeout=5
      Defaults        passwd_tries=3
    '';
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
    flake = "/home/zooki/.config/nix#shinzou";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandlePowerKey = "suspend";
    HandleSuspendKey = "suspend";
    HandleHibernateKey = "hibernate";
    IdleAction = "lock";
    IdleActionSec = "10min";
    RemoveIPC = "yes";
    KillUserProcesses = false;
    InhibitDelayMaxSec = "30";
  };

  system.stateVersion = "24.11";
}
