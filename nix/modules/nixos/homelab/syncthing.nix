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
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = {
        shinzou = {
          id = "PD677KN-SPMBZIG-W4D3S3Z-HCLNAWM-UKNCUMQ-AV7UEVG-MSUC2UI-ZBGE6Q3";
        };
        hashira = {
          id = "ZUUCCX3-HHPMMZK-ZZQJFEX-PARRWS5-NYYAWJI-RFKL57Z-LXETQAE-JXCFAQF";
        };
      };

      folders = {
        "obsidian" = {
          label = "Obsidian vault";
          path = "/srv/syncthing/zooki/obsidian";
          devices = [ "shinzou" ];
          ignorePerms = true;
          rescanIntervalS = 3600;
          fsWatcherEnabled = true;
        };
      };
    };
  };
}
