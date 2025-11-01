{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  cloudPackages = let
    packages = import (builtins.fetchGit {
      url = "https://github.com/NixOS/nixpkgs/";
      rev = "e89cf1c932006531f454de7d652163a9a5c86668";
    }) { system = if isDarwin then "aarch64-darwin" else "x86_64-linux"; };
    googleCloudSdk = packages.google-cloud-sdk-gce;
  in [
    (googleCloudSdk.withExtraComponents [
      googleCloudSdk.components.app-engine-python
      googleCloudSdk.components.app-engine-python-extras
    ])
  ];
in {

  programs.zsh.initExtra = lib.mkAfter ''
    if command -v gcloud >/dev/null 2>&1; then
      google_cloud_sdk_path=$(nix-store --query --requisites $(which gcloud) 2>/dev/null | grep google-cloud-sdk | head -n 1 || echo "")

      if [ -n "$google_cloud_sdk_path" ]; then
        export PATH="$google_cloud_sdk_path/bin:$PATH"

        if [ -f "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc" ]; then
          source "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc"
        fi
      fi
    fi

  '';

  home.packages = cloudPackages ++ [
    (pkgs.writeShellScriptBin "python2" ''
      exec ${pkgs.python27}/bin/python2.7 "$@"
    '')
    (pkgs.writeShellScriptBin "python2.7" ''
      exec ${pkgs.python27}/bin/python2.7 "$@"
    '')
    (pkgs.writeShellScriptBin "python" ''
      exec ${pkgs.python312}/bin/python3.12 "$@"
    '')
    (pkgs.writeShellScriptBin "python3" ''
      exec ${pkgs.python312}/bin/python3.12 "$@"
    '')
  ];
}
