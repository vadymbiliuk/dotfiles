{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  googleCloudSdkPkg = if isDarwin then
    let
      packages = import (builtins.fetchGit {
        url = "https://github.com/NixOS/nixpkgs/";
        rev = "e89cf1c932006531f454de7d652163a9a5c86668";
      }) { system = "aarch64-darwin"; };
      googleCloudSdk = packages.google-cloud-sdk-gce;
    in
      googleCloudSdk.withExtraComponents [
        googleCloudSdk.components.app-engine-python
        googleCloudSdk.components.app-engine-python-extras
      ]
  else null;
in {

  programs.fish.interactiveShellInit = lib.mkAfter (lib.optionalString isDarwin ''
    fish_add_path --prepend ${googleCloudSdkPkg}/bin
    if test -f ${googleCloudSdkPkg}/google-cloud-sdk/path.fish.inc
      source ${googleCloudSdkPkg}/google-cloud-sdk/path.fish.inc
    end
  '');

  home.packages = lib.optional isDarwin googleCloudSdkPkg;
}
