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
    };
  };

  security.sudo.wheelNeedsPassword = true;

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [ htop tmux rsync ncdu ];

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = false;
  };
}
