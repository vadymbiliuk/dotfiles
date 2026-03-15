{ config, pkgs, lib, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  imports = [ ../modules/profiles/workstation-darwin.nix ];

  system.stateVersion = 5;
  system.primaryUser = "vadymbiliuk";

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  users.users."vadymbiliuk" = {
    name = "vadymbiliuk";
    home = "/Users/vadymbiliuk";
    shell = pkgs.fish;
  };

  nix.settings.trusted-users = [ "root" "vadymbiliuk" ];

  system.activationScripts.postActivation.text = ''
    wallpaper="/Users/vadymbiliuk/.config/wallpapers/current"
    if [ -L "$wallpaper" ]; then
      wallpaper=$(readlink "$wallpaper")
    fi
    if [ -f "$wallpaper" ]; then
      /usr/bin/osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$wallpaper\""
    fi

    if ! pgrep -x "AeroSpace" > /dev/null; then
      sudo -u vadymbiliuk open -a AeroSpace
    fi
  '';

  home-manager.users.vadymbiliuk = {
    imports = [
      ../modules/home/base.nix
      ../modules/home/firefox.nix
      ../modules/home/kitty.nix
      ../modules/home/packages.nix
      ../modules/home/work.nix
    ];

    programs.neovim.package = unstable.neovim-unwrapped;
    programs.kitty.package = unstable.kitty;

    home.packages = [ unstable.opencode ];

    home.stateVersion = "24.05";
  };
}
