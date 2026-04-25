{ config, pkgs, lib, ... }:

{
  imports = [ ./base.nix ];

  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.device = lib.mkDefault "/dev/sda";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      MaxAuthTries = 3;
      LoginGraceTime = 30;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = false;
    };
  };

  security.sudo.wheelNeedsPassword = true;

  networking.firewall.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandlePowerKey = "ignore";
    IdleAction = "ignore";
  };

  environment.systemPackages = with pkgs; [ htop tmux rsync ncdu ];

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "127.0.0.0/8"
      "192.168.0.0/16"
      "100.64.0.0/10"
    ];
    maxretry = 3;
    bantime = "24h";
    bantime-increment = {
      enable = true;
      maxtime = "168h";
      factor = "4";
    };
    jails = {
      nginx-botsearch = {
        settings = {
          enabled = true;
          filter = "nginx-botsearch";
          logpath = "/var/log/nginx/access.log";
          maxretry = 2;
        };
      };
      nginx-bad-request = {
        settings = {
          enabled = true;
          filter = "nginx-bad-request";
          logpath = "/var/log/nginx/access.log";
          maxretry = 2;
        };
      };
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    allowReboot = false;
    operation = "boot";
  };
}
