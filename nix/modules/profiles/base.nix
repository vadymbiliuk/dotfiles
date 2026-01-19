{ config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-33.4.11"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [ git vim wget curl ];
}
