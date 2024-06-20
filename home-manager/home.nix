{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    username = "vadymbiliuk";
    homeDirectory = "/Users/vadymbiliuk";
    packages = [
      pkgs.git
      pkgs.black
      pkgs.prettierd
      pkgs.pre-commit
      pkgs.pyenv
      pkgs.nixfmt-classic
      pkgs.cargo
      pkgs.ruff
      pkgs.jdk21
      pkgs.vscode-langservers-extracted
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.fzf
      pkgs.fd
      pkgs.stack
      pkgs.cabal-install
      pkgs.haskellPackages.fourmolu
    ];
  };
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    plugins = [ ];
    shellInit = ''
      # Set EDITOR to nvim
      set -x EDITOR nvim

      set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
      set -gx PATH $HOME/.cabal/bin $PATH /Users/vadymbiliuk/.ghcup/bin # ghcup-env

    '';
    interactiveShellInit = ''
      # Disable fish greeting
      set fish_greeting

      # Initialize pyenv
      if type -q pyenv
        pyenv init - | source
      end

      # Configure fnm
      if type -q fnm
        fnm env --use-on-cd | source
      end

      # Configure gcp
      if [ -f '/Users/vadymbiliuk/google-cloud-sdk/path.fish.inc' ]; . '/Users/vadymbiliuk/google-cloud-sdk/path.fish.inc'; end
    '';
  };
}
