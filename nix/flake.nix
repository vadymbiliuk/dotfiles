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
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    drata-agent.url = "path:./drata-agent";
  };

  outputs = { self, nixpkgs, nix-darwin, determinate, home-manager, lanzaboote
    , ... }@inputs: {
      nixosConfigurations = {
        minazuki = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
            lanzaboote.nixosModules.lanzaboote
            ./hosts/minazuki.nix
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
    };
}

