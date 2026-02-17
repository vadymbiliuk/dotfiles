{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.locate.enable = true;
  services.fstrim.enable = true;

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "30m";
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
    ];
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

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    extensions = [ pkgs.postgresql_17.pkgs.pgvector ];
  };
}
