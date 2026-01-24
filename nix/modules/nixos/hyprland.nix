{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
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
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    wayland
    wayland-protocols
    wayland-utils
    wlroots
    hyprlock
    hypridle
  ];
  
  security.pam.services.hyprlock.text = ''
    auth include login
  '';
}
