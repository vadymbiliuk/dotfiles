{ config, pkgs, ... }: {
  enable = true;
  lfs.enable = true;
  userName = "Vadym Biliuk";
  userEmail = "vadym.biliuk@gmail.com";

  extraConfig = {
    pull = { rebase = true; };
    init = { defaultBranch = "main"; };
    gpg."ssh".program =
      "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };
}
