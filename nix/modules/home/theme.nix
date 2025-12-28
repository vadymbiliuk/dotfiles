{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
  ];
  
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Tela-circle-dracula";
      package = pkgs.tela-icon-theme;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "kvantum";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
  '';
}
