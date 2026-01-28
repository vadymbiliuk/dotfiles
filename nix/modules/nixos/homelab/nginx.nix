{ config, pkgs, lib, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "admin@zxxki.com";
      dnsProvider = "cloudflare";
      credentialFiles = {
        "CF_DNS_API_TOKEN_FILE" = config.sops.secrets.cloudflare-api-token.path;
      };
    };
    certs."zxxki.com" = {
      domain = "*.zxxki.com";
      extraDomainNames = [ "zxxki.com" ];
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "_" = {
        default = true;
        rejectSSL = true;
        locations."/" = {
          return = "444";
        };
      };

    };
  };
}
