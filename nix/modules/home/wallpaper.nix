{ pkgs, lib, ... }:

{
  home.packages = lib.optionals pkgs.stdenv.isLinux [ pkgs.swww ];

  home.file.".config/wallpapers/wallpaper.jpg".source = ../../wallpapers/wallpaper.jpg;
  home.file.".config/wallpapers/black.jpg".source = ../../wallpapers/black.jpg;
}
