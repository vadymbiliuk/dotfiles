{ config, pkgs, ... }: {
  enable = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  history.size = 10000;
  shellAliases = {
    vim = "nvim";
    v = "nvim";
    ga = "git add";
    gs = "git status";
    gc = "git checkout";
    gcm = "git commit";
    ls = "ls --color";
  };
  initExtra = ''
    ZSH_DISABLE_COMPFIX=true

    export EDITOR=nvim
    export PATH=$(pyenv root)/shims:$PATH

    if [ -z "$GHCUP_INSTALL_BASE_PREFIX" ]; then
        export GHCUP_INSTALL_BASE_PREFIX="$HOME"
    fi

    export PATH="$HOME/.cabal/bin:/Users/vadymbiliuk/.ghcup/bin:$PATH"  # ghcup-env

    # Find Google Cloud SDK path dynamically
    # Cache the path in a file once to avoid re-computation on every shell startup.
    google_cloud_sdk_path=$(nix-store --query --requisites $(which gcloud) | grep google-cloud-sdk | head -n 1)

    # Add Google Cloud SDK binaries to PATH
    export PATH="$google_cloud_sdk_path/bin:$PATH"

    # Source the Google Cloud SDK setup scripts
    if [ -f "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc" ]; then
      source "$google_cloud_sdk_path/google-cloud-sdk/path.zsh.inc"
    fi

    export PATH=~/.npm-global/bin:$PATH
    export LIBRARY_PATH="/usr/local/lib:$LIBRARY_PATH"
    export CPATH="/usr/local/include:$CPATH"
    export PG_CONFIG=/usr/bin/pg_config
    export PATH="/usr/local/opt/openssl/bin:$PATH"

    [[ ! -r '/Users/vadymbiliuk/.opam/opam-init/init.zsh' ]] || source '/Users/vadymbiliuk/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
  '';
  oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "sudo"
      "1password"
      "gcloud"
      "gh"
      "git-commit"
      "kitty"
      "ssh"
      "thefuck"
    ];
  };
}
