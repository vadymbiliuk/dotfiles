{
  config,
  pkgs,
  lib,
  ...
}:

{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
    flake = "/home/zooki/.config/nix#shinzou";
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "30m";
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
    ];
    jails.sshd.settings = {
      enabled = true;
      port = 22;
      filter = "sshd";
      maxretry = 3;
      findtime = 600;
      bantime = 3600;
    };
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

  security.sudo = {
    wheelNeedsPassword = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults        timestamp_timeout=5
      Defaults        passwd_tries=3
    '';
  };

  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
  ];

  security.pam.services.hyprlock.text = ''
    auth include login
  '';
}
