{ config, pkgs, lib, ... }:

{
  services.syncthing = {
    enable = true;
    user = "zooki";
    group = "users";
    dataDir = "/home/zooki";
    configDir = "/home/zooki/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    overrideDevices = false;
    overrideFolders = false;
  };
}
