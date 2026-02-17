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

    virtualHosts = {
      "_" = {
        default = true;
      };

      "vpn.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };

      "vault.zxxki.com" = {
        useACMEHost = "zxxki.com";
        forceSSL = true;
        extraConfig = ''
          modsecurity on;
          modsecurity_rules_file ${modsecConfig};
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
      };
    };
  };
}
