{ lib, config, pkgs, inputs, ... }:

{
  environment.systemPackages = [ pkgs.sbctl ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
