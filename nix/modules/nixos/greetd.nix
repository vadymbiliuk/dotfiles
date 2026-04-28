{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = builtins.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-session"
          "--asterisks"
          "--asterisks-char" "•"
          "--width" "60"
          "--window-padding" "2"
          "--container-padding" "2"
          "--prompt-padding" "1"
          "--greet-align" "center"
          "--greeting" "Welcome back."
          "--theme" "border=#3a3a3a;text=#deeeed;prompt=#888888;time=#555555;action=#888888;button=#deeeed;container=#0a0a0a;input=#deeeed"
          "--cmd" "niri-session"
        ];
        user = "greeter";
      };
    };
  };
}
