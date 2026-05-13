{ pkgs, ... }:

let
  theme = import ../themes/monochrome.nix;
  c = theme.colors.greeter;
  l = theme.layout.greeter;
in
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
          "--width" (toString l.width)
          "--window-padding" (toString l.windowPadding)
          "--container-padding" (toString l.containerPadding)
          "--prompt-padding" (toString l.promptPadding)
          "--greet-align" "center"
          "--greeting" "Welcome back."
          "--theme" "border=${c.border};text=${c.text};prompt=${c.prompt};time=${c.time};action=${c.action};button=${c.button};container=${c.container};input=${c.input}"
          "--cmd" "niri-session"
        ];
        user = "greeter";
      };
    };
  };
}
