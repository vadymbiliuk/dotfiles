{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers.fabric = {
      enable = true;
      package = pkgs.fabricServers.fabric-1_21_4;
      openFirewall = true;

      serverProperties = {
        server-port = 25565;
        motd = "hashira";
        max-players = 10;
        difficulty = "normal";
        gamemode = "survival";
        white-list = true;
        enable-command-block = true;
        view-distance = 12;
        simulation-distance = 10;
      };

      jvmOpts = "-Xmx4G -Xms2G";

      symlinks = {
        "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          lithium = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/u8pHPXJl/lithium-fabric-0.15.3%2Bmc1.21.4.jar";
            sha256 = "sha256-FTiR6NaYj+3/pQmIUacloTfD5coEqJqN9An+sxNiPrQ=";
          };
        });
      };
    };
  };
}
