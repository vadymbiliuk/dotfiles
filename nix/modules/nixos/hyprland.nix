{ pkgs, lib, ... }:

let
  inherit (lib) mkDefault;

  theme-name = "MonoThemeDark";
  icon-theme-name = "MonoIcons";

  gtksettings = ''
    [Settings]
    gtk-icon-theme-name = ${icon-theme-name}
    gtk-theme-name = ${theme-name}
  '';
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = gtksettings;
    "xdg/gtk-4.0/settings.ini".text = gtksettings;
  };

  environment.variables.GTK_THEME = theme-name;

  programs.dconf = {
    enable = mkDefault true;
    profiles = {
      user = {
        databases = [
          {
            lockAll = false;
            settings = {
              "org/gnome/desktop/interface" = {
                gtk-theme = theme-name;
                icon-theme = icon-theme-name;
                color-scheme = "prefer-dark";
              };
            };
          }
        ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config.common = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };

  environment.systemPackages = with pkgs; [
    gtk3
    gtk4
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wayland
    wayland-protocols
    wayland-utils
    wlroots
    grim
    slurp
    wl-clipboard
    swww
    hyprlock
    hypridle
  ];

  security.pam.services.hyprlock.text = ''
    auth include login
  '';
}
