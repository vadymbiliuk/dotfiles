{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 600;
        command = "loginctl lock-session";
      }
    ];
    events = {
      before-sleep = "loginctl lock-session";
      lock = "${pkgs.swaylock-effects}/bin/swaylock -f";
    };
  };
}
