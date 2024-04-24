{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
    username = "vadymbiliuk";
    homeDirectory = "/Users/vadymbiliuk";
    packages = [
      pkgs.git
      pkgs.neovim
      pkgs.black
      pkgs.prettierd
      pkgs.pre-commit
      pkgs.pyenv
      pkgs.nixfmt
      pkgs.cargo
      pkgs.ruff
      pkgs.jdk21
      pkgs.vscode-langservers-extracted
      pkgs.nodejs
      pkgs.ripgrep
      pkgs.fzf
      pkgs.fd
    ];
  };
  programs.home-manager.enable = true;
  programs.fish.enable = true;
}
