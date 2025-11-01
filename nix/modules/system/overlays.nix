{ inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev:
      let
        unstablePkgs = import inputs.nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
      in {
        _1password-cli = unstablePkgs._1password-cli;
        _1password-gui = unstablePkgs._1password-gui;
      })
  ];
}
