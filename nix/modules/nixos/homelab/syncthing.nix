{ config, pkgs, lib, ... }:

{
  services.syncthing = {
    enable = true;
    user = "zooki";
    group = "users";
    dataDir = "/home/zooki";
    configDir = "/home/zooki/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
    overrideDevices = false;
    overrideFolders = false;
  };
}
