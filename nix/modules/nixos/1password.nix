{ config, lib, pkgs, ... }:

{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "minazuki" ];
  };

  security.pam.services.hyprlock = { };
}
