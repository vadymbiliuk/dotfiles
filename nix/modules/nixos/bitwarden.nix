{ config, lib, pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs; [
    unstable.bitwarden-desktop
    bitwarden-cli
    gcr_4
    libsecret
  ];

  services.dbus.packages = [ pkgs.gcr_4 ];

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.hyprlock = { };
  security.pam.services.sddm.enableGnomeKeyring = true;
}
