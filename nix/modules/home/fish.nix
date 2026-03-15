{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  programs.fish = {
    enable = true;

    shellAliases = {
      vim = "nvim";
      v = "nvim";
      lg = "lazygit";

      tm = "tmux";
      tma = "tmux attach";
      tmls = "tmux list-sessions";
      tmks = "tmux kill-session -t";
      tmn = "tmux new-session -s";

      zi = "__zoxide_zi";
      za = "zoxide add";
      zq = "zoxide query";
      zr = "zoxide remove";
    };

    shellAbbrs = {
      cat = "bat";
      ls = "eza";
      j = "just";
      m = "make";

      c = "cargo";
      cc = "cargo check";
      cb = "cargo build";
      cbr = "cargo build --release";
      cr = "cargo run";
      ct = "cargo test";
      cfa = "cargo fmt --all";

      ga = "git add";
      gs = "git status";
      gc = "git checkout";
      gcm = "git commit";
      grr = "git rebase --continue";
      gac = "git add --all && git commit -m";
      gap = "git commit --amend --no-edit && git push --force-with-lease";
      gaap = "git add --all && git commit --amend --no-edit && git push --force-with-lease";
      grim = "git fetch && git rebase -i --autostash origin/main";
    };

    functions = {
      z = {
        body = "__zoxide_z $argv";
      };

      lf = {
        wraps = "lf";
        description = "lf - Terminal file manager (changing directory on exit)";
        body = ''cd "(command lf -print-last-dir $argv)"'';
      };
    };

    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      end

      if test -e "$HOME/.nix-profile/etc/profile.d/nix.fish"
        source "$HOME/.nix-profile/etc/profile.d/nix.fish"
      end

      set -gx NIX_PATH "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels"

      fish_add_path --prepend --move ~/.nix-profile/bin
      fish_add_path --prepend --move /nix/var/nix/profiles/default/bin
      fish_add_path --prepend --move /run/current-system/sw/bin
      fish_add_path --prepend --move /etc/profiles/per-user/$USER/bin

      ${lib.optionalString isDarwin ''
        fish_add_path --prepend --move /opt/homebrew/bin
      ''}
    '';

    interactiveShellInit = ''
      set -g fish_greeting

      fish_vi_key_bindings

      set -gx EDITOR nvim
      set -gx XDG_CONFIG_HOME "$HOME/.config"
      set -gx DIRENV_LOG_FORMAT ""
      set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"

      ${lib.optionalString isDarwin ''
        set -gx CC /usr/bin/clang
        set -gx CXX /usr/bin/clang++

        fish_add_path --prepend --move /opt/homebrew/bin

        if type -q pyenv
          set -gx PYENV_ROOT "$HOME/.pyenv"
          fish_add_path --prepend $PYENV_ROOT/bin
          pyenv init - | source
        end

        if type -q rbenv
          set -gx RBENV_ROOT "$HOME/.rbenv"
          rbenv init - fish | source
        end
      ''}

      set -g __fish_git_prompt_char_stateseparator ' '
      set -g __fish_git_prompt_use_informative_chars 'yes'
      set -g __fish_git_prompt_color_dirtystate yellow
      set -g __fish_git_prompt_char_dirtystate '~'
      set -g __fish_git_prompt_char_untrackedfiles '+'
      set -g __fish_git_prompt_showuntrackedfiles 'yes'

      if type -q pokemonsay
        set -l hour (date +%H)
        if test $hour -ge 5 -a $hour -lt 12
          set greeting "ohayou"
        else if test $hour -ge 12 -a $hour -lt 18
          set greeting "konnichiwa"
        else
          set greeting "konbanwa"
        end
        pokemonthink --pokemon Gengar -N "$greeting"
      end
    '';

    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };

  programs.starship.enableFishIntegration = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = lib.mkForce true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
  };
}
