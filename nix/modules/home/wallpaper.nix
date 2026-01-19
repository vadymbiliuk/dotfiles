{
  config,
  pkgs,
  lib,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;

  wallpaperDir = "${config.home.homeDirectory}/.config/wallpapers";
  currentWallpaper = "${wallpaperDir}/current";
in
{
  home.packages = lib.optionals isLinux (
    with pkgs;
    [
      swww
      waypaper
    ]
  );

  home.file.".config/wallpapers/wallpaper.jpg".source = ../../wallpapers/wallpaper.jpg;
  home.file.".config/wallpapers/black.jpg".source = ../../wallpapers/black.jpg;

  home.activation.setWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -L "${currentWallpaper}" ]; then
      ln -sf "${wallpaperDir}/wallpaper.jpg" "${currentWallpaper}"
    fi
  '';
}
