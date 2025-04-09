{ pkgs, ... }: {
  enable = true;
  enableZshIntegration = true;
  settings = {
    add_newline = false;
    character = {
      success_symbol = "[->](bold white)";
      error_symbol = "[->](bold red)";
    };
  };
}
