{ config, pkgs, lib, ... }:

let
  notifyScript = pkgs.writers.writeHaskell "fail2ban-notify"
    {
      libraries = [
        pkgs.haskellPackages.http-conduit
        pkgs.haskellPackages.aeson
        pkgs.haskellPackages.directory
      ];
    }
    (builtins.readFile ./Notify.hs);

  notifyAction = pkgs.writeText "notify.conf" ''
    [Definition]
    actionban = ${notifyScript} <ip> <name>
  '';
in
{
  environment.etc."fail2ban/action.d/notify.conf".source = notifyAction;

  systemd.tmpfiles.rules = [
    "d /var/lib/fail2ban-notify 0755 root root -"
  ];

  services.fail2ban.jails = {
    sshd.settings.action = "%(action_)s\n           notify";
    nginx-botsearch.settings.action = "%(action_)s\n           notify";
    nginx-bad-request.settings.action = "%(action_)s\n           notify";
  };
}
