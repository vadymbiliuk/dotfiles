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
    plugins = [
      {
        name = "fish-prompt-mono";
        src = pkgs.fetchFromGitHub {
          owner = "fishpkg";
          repo = "fish-prompt-mono";
          rev = "8ac13592d47b746a4549bcecf21549f97ad66edb";
          sha256 = "0w618la3ggri1z2mlkkxczrr22xih6c795jgmf2634v2c1349cjq";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "ac01d96fc6344ebeb48c03f2c9c0be5bf3b20f1c";
          sha256 = "1h97zh3ghcvvn2x9rj51frhhi85nf7wa072g9mm2pc6sg71ijw4k";
        };
      }
      {
        name = "plugin-bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "4ac4ddee91d593f7a5ffb50de60ebd85566f5a15";
          sha256 = "0w618la3ggri1z2mlkkxczrr22xih6c795jgmf2634v2c1349cjq";
        };
      }
      {
        name = "fish-ssh-agent";
        src = pkgs.fetchFromGitHub {
          owner = "danhper";
          repo = "fish-ssh-agent";
          rev = "df0de37a6cd039e27433a20195d36d156d363e40";
          sha256 = "0w618la3ggri1z2mlkkxczrr22xih6c795jgmf2634v2c1349cjq";
        };
      }
    ];
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
