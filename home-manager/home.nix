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
    shellInit = ''
      # Set EDITOR to nvim
      set -x EDITOR nvim

      set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME
      set -gx PATH $HOME/.cabal/bin $PATH /Users/vadymbiliuk/.ghcup/bin # ghcup-env

      source /opt/homebrew/share/google-cloud-sdk/path.fish.inc
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
