{
  description = "Flake configuration for NixOS and Darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      determinate,
      home-manager,
      lanzaboote,
      sops-nix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        shinzou = inputs.nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            ./hosts/shinzou.nix
          ];
          specialArgs = { inherit inputs; };
        };

        hashira = inputs.nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            ./hosts/hashira.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations = {
        vadymbiliuk = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            determinate.darwinModules.default
            home-manager.darwinModules.home-manager
            ./hosts/vadymbiliuk.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      packages.x86_64-linux = {
        hashira-vm = self.nixosConfigurations.hashira.config.system.build.vm;
      };
    };
}
