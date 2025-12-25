{ config, pkgs, lib, ... }:

{
  home.file = {
    ".config/quickshell" = {
      source = ./quickshell;
      recursive = true;
    };
  };
}