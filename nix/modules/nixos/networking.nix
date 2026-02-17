{ config, pkgs, lib, ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
