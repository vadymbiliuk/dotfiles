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
  ];

  security.pam.services.hyprlock = { };
}
