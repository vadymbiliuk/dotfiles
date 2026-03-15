{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  cloudPackages = if isDarwin then
    let
      packages = import (builtins.fetchGit {
        url = "https://github.com/NixOS/nixpkgs/";
        rev = "e89cf1c932006531f454de7d652163a9a5c86668";
      }) { system = "aarch64-darwin"; };
      googleCloudSdk = packages.google-cloud-sdk-gce;
    in [
      (googleCloudSdk.withExtraComponents [
        googleCloudSdk.components.app-engine-python
        googleCloudSdk.components.app-engine-python-extras
      ])
    ]
  else [];
in {

  programs.fish.interactiveShellInit = lib.mkAfter ''
    ${lib.optionalString isDarwin ''
      if type -q gcloud
        set -l google_cloud_sdk_path (nix-store --query --requisites (which gcloud) 2>/dev/null | grep google-cloud-sdk | head -n 1)

        if test -n "$google_cloud_sdk_path"
          fish_add_path --prepend $google_cloud_sdk_path/bin

          if test -f "$google_cloud_sdk_path/google-cloud-sdk/path.fish.inc"
            source "$google_cloud_sdk_path/google-cloud-sdk/path.fish.inc"
          end
        end
      end
    ''}
  '';

  home.packages = cloudPackages;
}
