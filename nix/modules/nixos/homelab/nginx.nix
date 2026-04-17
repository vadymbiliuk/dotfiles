{ config, pkgs, lib, ... }:

let
  modsecConfig = pkgs.writeText "modsecurity.conf" ''
    SecRuleEngine On
    SecRequestBodyAccess On
    SecRequestBodyLimit 13107200
    SecRequestBodyNoFilesLimit 131072
    SecResponseBodyAccess Off
    SecTmpDir /tmp/modsecurity_tmp
    SecDataDir /tmp/modsecurity_data
    SecAuditEngine RelevantOnly
    SecAuditLogRelevantStatus "^(?:5|4(?!04))"
    SecAuditLogType Serial
    SecAuditLog /var/log/nginx/modsec_audit.log
    SecArgumentSeparator &
    SecCookieFormat 0
    SecStatusEngine Off
    Include ${pkgs.modsecurity-crs}/share/modsecurity-crs/crs-setup.conf.example
    Include ${pkgs.modsecurity-crs}/rules/*.conf
  '';
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
    additionalModules = [ pkgs.nginxModules.modsecurity ];
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=general:10m rate=10r/s;
      limit_req_zone $binary_remote_addr zone=login:10m rate=3r/m;

      map $http_user_agent $bad_bot {
        default 0;
        ~*(?:scrapy|bot|spider|crawl|wget|curl|nikto|sqlmap|nmap|masscan) 1;
      }
    '';

    commonHttpConfig = ''
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-XSS-Protection "1; mode=block" always;
      add_header Referrer-Policy "strict-origin-when-cross-origin" always;
      add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
      add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
    '';

    virtualHosts = {
      "_" = {
        default = true;
        extraConfig = ''
          return 444;
        '';
      };

      "vpn.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        extraConfig = ''
          modsecurity on;
          modsecurity_rules_file ${modsecConfig};

          if ($bad_bot) { return 444; }
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          extraConfig = ''
            limit_req zone=general burst=20 nodelay;
          '';
        };
      };

      "vault.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        extraConfig = ''
          modsecurity on;
          modsecurity_rules_file ${modsecConfig};

          if ($bad_bot) { return 444; }
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
          extraConfig = ''
            limit_req zone=general burst=20 nodelay;
          '';
        };
        locations."/api/accounts" = {
          proxyPass = "http://127.0.0.1:8222";
          extraConfig = ''
            limit_req zone=login burst=5 nodelay;
          '';
        };
      };

      "jellyfin.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        extraConfig = ''
          if ($bad_bot) { return 444; }
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 20M;
          '';
        };
      };

      "requests.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        extraConfig = ''
          if ($bad_bot) { return 444; }
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
          proxyWebsockets = true;
        };
      };
    };
  };
}
