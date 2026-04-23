{ config, pkgs, lib, ... }:

let
  wellKnownServer = pkgs.writeText "matrix-server.json"
    (builtins.toJSON { "m.server" = "matrix.zxxki.com:443"; });
  wellKnownClient = pkgs.writeText "matrix-client.json"
    (builtins.toJSON { "m.homeserver" = { base_url = "https://matrix.zxxki.com"; }; });
  wellKnownDir = pkgs.runCommand "matrix-well-known" {} ''
    mkdir -p $out
    cp ${wellKnownServer} $out/matrix-server.json
    cp ${wellKnownClient} $out/matrix-client.json
  '';
in
{
  services.matrix-conduit = {
    enable = true;
    settings.global = {
      server_name = "zxxki.com";
      port = 6167;
      address = "127.0.0.1";
      database_backend = "rocksdb";
      max_request_size = 20000000;
      allow_registration = false;
      allow_federation = true;
      trusted_servers = [ "matrix.org" ];
    };
  };

  services.nginx.virtualHosts."matrix.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:6167";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 20M;
      '';
    };
    locations."/_matrix/" = {
      proxyPass = "http://127.0.0.1:6167";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 20M;
      '';
    };
  };

  services.nginx.virtualHosts."zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    root = wellKnownDir;
    locations."/.well-known/matrix/server" = {
      tryFiles = "/matrix-server.json =404";
      extraConfig = ''
        default_type application/json;
        add_header Access-Control-Allow-Origin * always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
        add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
      '';
    };
    locations."/.well-known/matrix/client" = {
      tryFiles = "/matrix-client.json =404";
      extraConfig = ''
        default_type application/json;
        add_header Access-Control-Allow-Origin * always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
        add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
      '';
    };
  };
}
