{ config, lib, pkgs, ... }:

let
  mono-gtk-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "mono-gtk-theme";
    version = "1.3";
    src = pkgs.fetchurl {
      url = "https://github.com/witalihirsch/Mono-gtk-theme/releases/download/1.3/MonoThemeDark.tar.xz";
      hash = "sha256-PeKFr+ZPDYWyZziLbdQBE4C1wov059WEdDiQZWTX5Yk=";
    };
    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/themes
      cp -r MonoThemeDark $out/share/themes/
    '';
  };

  mono-icon-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "mono-icon-theme";
    version = "0.1";
    src = pkgs.fetchurl {
      url = "https://github.com/witalihirsch/Mono-icon-theme/releases/download/0.1/MonoIcons.zip";
      hash = "sha256-V3fuK8SV8Ksmn157a97RzI3mQ/dXKGy0MflNNi2Vc88=";
    };
    sourceRoot = ".";
    nativeBuildInputs = [ pkgs.unzip ];
    dontConfigure = true;
    dontBuild = true;
    dontCheckForBrokenSymlinks = true;
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r MonoIcons $out/share/icons/
    '';
  };
in
{
  gtk = {
    enable = true;
    theme = {
      name = "MonoThemeDark";
      package = mono-gtk-theme;
    };
    iconTheme = {
      name = "MonoIcons";
      package = mono-icon-theme;
    };
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
    gtk4.extraConfig = { gtk-application-prefer-dark-theme = true; };
  };

  xdg.configFile."gtk-4.0/assets".source = "${mono-gtk-theme}/share/themes/MonoThemeDark/gtk-4.0/assets";
  xdg.configFile."gtk-4.0/gtk.css".source = "${mono-gtk-theme}/share/themes/MonoThemeDark/gtk-4.0/gtk.css";
  xdg.configFile."gtk-4.0/gtk-dark.css".source = "${mono-gtk-theme}/share/themes/MonoThemeDark/gtk-4.0/gtk-dark.css";

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=KvDark
  '';
}
