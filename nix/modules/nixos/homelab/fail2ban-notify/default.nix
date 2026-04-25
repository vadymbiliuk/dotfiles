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
    actionban = ${notifyScript} record <ip> <name>
  '';

  sshLoginAlert = pkgs.writeShellScript "ssh-login-alert" ''
    DISCORD_URL=$(cat /run/secrets/grafana-discord-webhook)
    TELEGRAM_TOKEN=$(cat /run/secrets/grafana-telegram-token)
    CHAT_ID="133081420"

    USER="$PAM_USER"
    IP="$PAM_RHOST"
    [ "$PAM_TYPE" != "open_session" ] && exit 0
    [ -z "$IP" ] && exit 0

    KNOWN_IPS=$(cat /etc/ssh/known_login_ips 2>/dev/null || echo "")
    for known in $KNOWN_IPS; do
      [ "$IP" = "$known" ] && exit 0
    done

    MSG="[SSH LOGIN] User: $USER from $IP ($(date '+%Y-%m-%d %H:%M:%S'))"

    ${pkgs.curl}/bin/curl -s -X POST "$DISCORD_URL" \
      -H "Content-Type: application/json" \
      -d "{\"content\": \"$MSG\"}"

    ${pkgs.curl}/bin/curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
      -H "Content-Type: application/json" \
      -d "{\"chat_id\": \"$CHAT_ID\", \"text\": \"$MSG\"}"
  '';
in
{
  environment.etc."fail2ban/action.d/notify.conf".source = notifyAction;
  environment.etc."ssh/known_login_ips".text = "";

  systemd.tmpfiles.rules = [
    "d /var/lib/fail2ban-notify 0755 root root -"
  ];

  services.fail2ban.jails = {
    sshd.settings.action = "%(action_)s\n           notify";
    nginx-botsearch.settings.action = "%(action_)s\n           notify";
    nginx-bad-request.settings.action = "%(action_)s\n           notify";
  };

  systemd.services.fail2ban-digest = {
    description = "Send daily fail2ban ban digest";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${notifyScript} digest";
    };
  };

  systemd.timers.fail2ban-digest = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 09:00:00";
      Persistent = true;
    };
  };

  security.pam.services.sshd.rules.session.ssh-login-alert = {
    order = 99999;
    control = "optional";
    modulePath = "pam_exec.so";
    args = [ "${sshLoginAlert}" ];
  };
}
