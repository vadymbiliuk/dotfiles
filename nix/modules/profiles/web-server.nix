{ config, pkgs, lib, ... }:

{
  imports = [ ./server-base.nix ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = lib.mkDefault "admin@example.com";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
