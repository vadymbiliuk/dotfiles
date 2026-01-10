# Host Configuration Examples

This directory contains host-specific configurations. Each host imports profiles from `modules/profiles/` to compose its functionality.

## Available Profiles

### Base & Workstation
- `profiles/base.nix` - Minimal base configuration for all machines
- `profiles/workstation-linux.nix` - Linux desktop environment setup
- `profiles/gaming.nix` - Gaming-specific configuration
- `profiles/development.nix` - Development tools

### Server Profiles
- `profiles/server-base.nix` - Base server configuration (SSH, fail2ban, auto-upgrade)
- `profiles/docker-host.nix` - Docker container host
- `profiles/web-server.nix` - Nginx web server with ACME/SSL
- `profiles/media-server.nix` - Media server (Jellyfin/Plex ready)
- `profiles/database-server.nix` - Database server (PostgreSQL/MySQL/Redis)

## Example Configurations

### Simple Web Server

```nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/profiles/web-server.nix
  ];

  networking.hostName = "webserver1";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  security.acme.defaults.email = "you@example.com";

  system.stateVersion = "24.11";
}
```

### Docker + Web Server Combo

```nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/profiles/docker-host.nix
    ../modules/profiles/web-server.nix
  ];

  networking.hostName = "appserver1";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  system.stateVersion = "24.11";
}
```

### Media Server

```nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/profiles/media-server.nix
  ];

  networking.hostName = "mediaserver";

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  system.stateVersion = "24.11";
}
```

### Database Server

```nix
{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/profiles/database-server.nix
  ];

  networking.hostName = "dbserver";

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    authentication = ''
      host all all 192.168.1.0/24 scram-sha-256
    '';
  };

  networking.firewall.allowedTCPPorts = [ 5432 ];

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  system.stateVersion = "24.11";
}
```

## Adding to flake.nix

```nix
outputs = { self, nixpkgs, ... }@inputs: {
  nixosConfigurations = {
    minazuki = nixpkgs.lib.nixosSystem { ... };

    webserver1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/webserver1.nix ];
      specialArgs = { inherit inputs; };
    };

    appserver1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/appserver1.nix ];
      specialArgs = { inherit inputs; };
    };
  };
};
```

## Benefits

- **Minimal host files**: Only specify what's unique (hostname, users, specific services)
- **Composable**: Mix and match profiles (e.g., docker-host + web-server)
- **Reusable**: Same profile for multiple similar servers
- **Easy to maintain**: Update profile once, affects all hosts using it
