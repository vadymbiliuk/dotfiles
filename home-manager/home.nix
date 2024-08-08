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
      pkgs.vscode-langservers-extracted
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.fzf
      pkgs.fd
      pkgs.stack
      pkgs.cabal-install
      pkgs.haskellPackages.fourmolu
      pkgs.poetry
      pkgs.jdk11
    ];
  };
  programs.home-manager.enable = true;
  programs.fish = {
    enable = true;
    plugins = [ ];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # Set EDITOR to nvim
      set -x EDITOR nvim

      set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
      set -gx PATH $HOME/.cabal/bin $PATH /Users/vadymbiliuk/.ghcup/bin # ghcup-env

      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
         fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end

      starship init fish | source

      status is-interactive; and source (pyenv init --path | psub)

      # Configure fnm
      if type -q fnm
        fnm env --use-on-cd | source
      end

      # Source Google Cloud SDK path setup
      set GOOGLE_CLOUD_SDK (brew --prefix)/share/google-cloud-sdk
      source $GOOGLE_CLOUD_SDK/path.fish.inc

      # Source Google Cloud SDK completion setup
      # bash source $GOOGLE_CLOUD_SDK/completion.bash.inc

      alias v "nvim" 
      alias vi "nvim" 
    '';
    shellInit = ''
      set -gx fish_color_end 7a7a7a
      set -gx fish_color_error ffaa88
      set -gx fish_color_quote 708090
      set -gx fish_color_param aaaaaa
      set -gx fish_color_option aaaaaa
      set -gx fish_color_normal CCCCCC
      set -gx fish_color_escape 789978
      set -gx fish_color_comment 555555
      set -gx fish_color_command CCCCCC
      set -gx fish_color_keyword 7a7a7a
      set -gx fish_color_operator 7788aa
      set -gx fish_color_redirection ffaa88
      set -gx fish_color_autosuggestion 2a2a2a
      set -gx fish_color_selection --background=555555
      set -gx fish_color_search_match --background=555555
      set -gx fish_pager_color_prefix 999999
      set -gx fish_pager_color_progress 555555
      set -gx fish_pager_color_completion cccccc
      set -gx fish_pager_color_description 7a7a7a
      set -gx fish_pager_color_selected_background --background=555555
    '';
  };
}
