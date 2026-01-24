{ config, pkgs, lib, ... }:

let
  headscale-ui = pkgs.stdenv.mkDerivation rec {
    pname = "headscale-ui";
    version = "2025.01.20";
    src = pkgs.fetchzip {
      url = "https://github.com/gurucomputing/headscale-ui/releases/download/${version}/headscale-ui.zip";
      hash = "sha256-eMT3/UsTYkiJFzoWlNPOM6hgbyGoBbPi3cs/u71KJ0c=";
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/headscale-ui
      cp -r * $out/share/headscale-ui/
    '';
  };
in
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

      "hs.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        root = "${headscale-ui}/share/headscale-ui";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
      };
    };
  };
}
