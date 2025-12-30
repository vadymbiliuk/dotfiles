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
    flake = "/home/minazuki/.config/nix#minazuki";
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
    extraConfig = ''
      HandlePowerKey=suspend
      HandleSuspendKey=suspend
      HandleHibernateKey=hibernate
      HandleLidSwitch=suspend
      HandleLidSwitchDocked=suspend
      IdleAction=lock
      IdleActionSec=10min
      RemoveIPC=yes
      KillUserProcesses=no
      InhibitDelayMaxSec=30
    '';
  };

  system.stateVersion = "24.11";
}
