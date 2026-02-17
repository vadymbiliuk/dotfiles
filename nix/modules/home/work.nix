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

  programs.zsh.initContent = lib.mkAfter ''
    ${lib.optionalString isDarwin ''
      if command -v gcloud >/dev/null 2>&1; then
        google_cloud_sdk_path=$(nix-store --query --requisites $(which gcloud) 2>/dev/null | grep google-cloud-sdk | head -n 1 || echo "")

        if [ -n "$google_cloud_sdk_path" ]; then
          export PATH="$google_cloud_sdk_path/bin:$PATH"

          if [ -f "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc" ]; then
            source "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc"
          fi
        fi
      fi
    ''}
  '';

  home.packages = cloudPackages;
}
