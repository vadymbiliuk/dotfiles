{ config, pkgs, lib, inputs, ... }:

let
  dashPkg = inputs.hashira-dash.packages.x86_64-linux.default;

  localIp = "192.168.0.190";

  publicServices = [
    { name = "Jellyfin"; description = "Movies, shows & music"; icon = "film"; category = "Media"; port = 8096; subdomain = "watch"; }
    { name = "Jellyseerr"; description = "Media requests"; icon = "inbox"; category = "Media"; port = 5055; subdomain = "r-media"; }
    { name = "Kavita"; description = "Book library"; icon = "book-open"; category = "Media"; port = 5000; subdomain = "read"; }
    { name = "LazyLibrarian"; description = "Book requests"; icon = "search"; category = "Media"; port = 5299; subdomain = "r-books"; }
    { name = "Vaultwarden"; description = "Password manager"; icon = "lock"; category = "Security"; port = 8222; subdomain = "vault"; }
    { name = "Headscale"; description = "VPN control plane"; icon = "shield"; category = "Security"; port = 8080; subdomain = "vpn"; }
    { name = "Matrix"; description = "Messaging"; icon = "message-square"; category = "Infrastructure"; port = 6167; subdomain = "matrix"; }
  ];

  friendServices = [
    { name = "Gitea"; description = "Git repositories"; icon = "git-branch"; category = "Development"; port = 3300; subdomain = "git"; }
    { name = "RabbitMQ"; description = "Message broker"; icon = "zap"; category = "Infrastructure"; port = 15672; subdomain = "rabbitmq"; }
    { name = "Redis"; description = "Key-value store"; icon = "database"; category = "Database"; port = 6379; subdomain = "redis"; }
    { name = "Kafka"; description = "Event streaming"; icon = "radio"; category = "Database"; port = 9092; subdomain = "kafka"; }
    { name = "PostgreSQL"; description = "Relational database"; icon = "server"; category = "Database"; port = 5432; subdomain = "postgresql"; }
    { name = "MongoDB"; description = "Document database"; icon = "server"; category = "Database"; port = 27017; subdomain = "mongodb"; }
    { name = "Neo4j"; description = "Graph database"; icon = "share-2"; category = "Database"; port = 7474; subdomain = "neo4j"; }
    { name = "Minecraft"; description = "Game server"; icon = "gamepad"; category = "Gaming"; port = 25565; subdomain = "minecraft"; }
  ];

  familyServices = [
    { name = "Grafana"; description = "Dashboards & alerts"; icon = "activity"; category = "Monitoring"; port = 3100; subdomain = "grafana"; }
    { name = "Prometheus"; description = "Metrics collection"; icon = "bar-chart-2"; category = "Monitoring"; port = 9090; subdomain = "prometheus"; }
    { name = "Portainer"; description = "Container management"; icon = "box"; category = "Infrastructure"; port = 9000; subdomain = "portainer"; }
    { name = "Home Assistant"; description = "Home automation"; icon = "home"; category = "Infrastructure"; port = 8123; subdomain = "ha"; }
    { name = "AdGuard Home"; description = "DNS ad blocking"; icon = "eye-off"; category = "Network"; port = 3000; subdomain = "adguard"; }
    { name = "Syncthing"; description = "File synchronization"; icon = "refresh-cw"; category = "Infrastructure"; port = 8384; subdomain = "syncthing"; }
    { name = "qBittorrent"; description = "Torrent client"; icon = "download"; category = "Media"; port = 8112; subdomain = "qbit"; }
    { name = "Sonarr"; description = "TV show management"; icon = "tv"; category = "Media"; port = 8989; subdomain = "sonarr"; }
    { name = "Radarr"; description = "Movie management"; icon = "film"; category = "Media"; port = 7878; subdomain = "radarr"; }
    { name = "Lidarr"; description = "Music management"; icon = "music"; category = "Media"; port = 8686; subdomain = "lidarr"; }
    { name = "Readarr"; description = "Book management"; icon = "book-open"; category = "Media"; port = 8787; subdomain = "readarr"; }
    { name = "Bazarr"; description = "Subtitle management"; icon = "subtitles"; category = "Media"; port = 6767; subdomain = "bazarr"; }
    { name = "Prowlarr"; description = "Indexer management"; icon = "search"; category = "Media"; port = 9696; subdomain = "prowlarr"; }
    { name = "FlareSolverr"; description = "Cloudflare bypass"; icon = "cloud"; category = "Media"; port = 8191; subdomain = "flaresolverr"; }
    { name = "CrowdSec"; description = "Threat detection"; icon = "shield"; category = "Security"; port = 6060; subdomain = "crowdsec"; }
  ];

  allFriendServices = publicServices ++ friendServices;
  allFamilyServices = publicServices ++ friendServices ++ familyServices;

  mkServiceJson = network: svc: {
    inherit (svc) name description icon category;
    url =
      if network == "local" then "http://${localIp}:${toString svc.port}"
      else if network == "tailscale" then "http://hashira:${toString svc.port}"
      else "https://${svc.subdomain}.zxxki.com";
  };

  mkFlags = network: services: builtins.toJSON {
    inherit network;
    services = map (mkServiceJson network) services;
  };

  mkHtml = network: services:
    let flags = mkFlags network services; in
    ''
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Hashira</title>
        <link rel="stylesheet" href="/style.css">
      </head>
      <body>
        <script src="/elm.js"></script>
        <script>Elm.Main.init({ flags: ${flags} });</script>
      </body>
      </html>
    '';

  dashRoot = pkgs.runCommand "hashira-dash-site" {} ''
    mkdir -p $out
    cp ${dashPkg}/elm.js $out/
    cp ${dashPkg}/style.css $out/
    cat > $out/index-local.html <<'HTMLEOF'
    ${mkHtml "local" allFamilyServices}
    HTMLEOF
    cat > $out/index-tailscale.html <<'HTMLEOF'
    ${mkHtml "tailscale" allFriendServices}
    HTMLEOF
    cat > $out/index-public.html <<'HTMLEOF'
    ${mkHtml "public" publicServices}
    HTMLEOF
  '';
in
{
  services.nginx.virtualHosts."dash.zxxki.com" = {
    useACMEHost = "zxxki.com";
    forceSSL = true;
    root = dashRoot;
    locations."= /" = {
      extraConfig = ''
        set $dash_index "index-public.html";
        if ($remote_addr ~ "^192\.168\.0\.") {
          set $dash_index "index-local.html";
        }
        if ($remote_addr ~ "^100\.(6[4-9]|[7-9][0-9]|1[0-2][0-7])\.") {
          set $dash_index "index-tailscale.html";
        }
        rewrite ^ /$dash_index last;
      '';
    };
  };
}
