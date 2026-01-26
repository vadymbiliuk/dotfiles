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

      "vault.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
        };
      };

      "sync.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          proxyWebsockets = true;
        };
      };

      "dns.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
      };

      "vpn.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
        };
      };

    };
  };
}
