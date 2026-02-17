{ config, pkgs, lib, ... }:

{
  home-manager.sharedModules = [{ imports = [ ../home/packages.nix ]; }];
}
