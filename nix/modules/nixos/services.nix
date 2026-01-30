{ config, pkgs, lib, ... }:

{
  services.locate.enable = true;
  services.fstrim.enable = true;

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "30m";
    ignoreIP = [ "127.0.0.1/8" "::1" ];
    jails.sshd.settings = {
      enabled = true;
      port = 22;
      filter = "sshd";
      maxretry = 3;
      findtime = 600;
      bantime = 3600;
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "sugar-dark";
  };

  environment.systemPackages =
    let
      sddm-sugar-dark = pkgs.stdenv.mkDerivation {
        name = "sddm-sugar-dark";
        src = pkgs.fetchFromGitHub {
          owner = "MarianArlt";
          repo = "sddm-sugar-dark";
          rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
          hash = "sha256-flOspjpYezPvGZ6b4R/Mr18N7N3JdytCSwwu6mf4owQ=";
        };
        installPhase = ''
          mkdir -p $out/share/sddm/themes/sugar-dark
          cp -R ./* $out/share/sddm/themes/sugar-dark/
          rm $out/share/sddm/themes/sugar-dark/Background.jpg
          cp ${../../wallpapers/wallpaper.jpg} $out/share/sddm/themes/sugar-dark/Background.jpg
        '';
      };
    in
    [
      sddm-sugar-dark
      pkgs.libsForQt5.qt5.qtquickcontrols2
      pkgs.libsForQt5.qt5.qtgraphicaleffects
    ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    extensions = [ pkgs.postgresql_17.pkgs.pgvector ];
  };
}
