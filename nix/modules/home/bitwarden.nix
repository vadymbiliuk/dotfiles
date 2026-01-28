{ config, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1yHR4U8qcSV3xQjlmML+C1EmCr+7cif9++9YWZPUd2";
  allowedSignersFile = pkgs.writeText "allowed_signers" ''
    vadym.biliuk@gmail.com ${sshKey}
  '';

  bitwardenSettingsScript = pkgs.writeShellScript "configure-bitwarden" ''
    CONFIG_FILE="$HOME/.config/Bitwarden/data.json"
    [ ! -f "$CONFIG_FILE" ] && exit 0

    GLOBAL_SETTINGS='${builtins.toJSON {
      global_desktopSettings_openAtLogin = true;
      global_desktopSettings_trayEnabled = true;
      global_desktopSettings_closeToTray = true;
      global_desktopSettings_startToTray = true;
      global_desktopSettings_browserIntegrationEnabled = true;
      global_desktopSettings_hardwareAcceleration = true;
      global_desktopSettings_sshAgentEnabled = true;
    }}'

    USER_ID=$(${pkgs.jq}/bin/jq -r '.global_account_activeAccountId // empty' "$CONFIG_FILE")
    if [ -n "$USER_ID" ]; then
      USER_SETTINGS=$(${pkgs.jq}/bin/jq -n \
        --arg uid "$USER_ID" \
        '{
          ("user_" + $uid + "_biometricSettings_biometricUnlockEnabled"): true,
          ("user_" + $uid + "_desktopSettings_sshAgentRememberAuthorizations"): "rememberUntilLock"
        }')
      ${pkgs.jq}/bin/jq ". + $GLOBAL_SETTINGS + $USER_SETTINGS" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    else
      ${pkgs.jq}/bin/jq ". + $GLOBAL_SETTINGS" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    fi
  '';
in {
  services.gnome-keyring = lib.mkIf isLinux {
    enable = true;
    components = [ "secrets" ];
  };

  home.packages = with pkgs; lib.optionals isLinux [
  ];

  home.activation.configureBitwarden = lib.mkIf isLinux (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${bitwardenSettingsScript}
    ''
  );

  programs.git = {
    signing = {
      key = sshKey;
      signByDefault = true;
    };
    settings = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${allowedSignersFile}";
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${HOME}/.bitwarden-ssh-agent.sock";
    SOPS_AGE_KEY_CMD = "\${HOME}/.local/bin/sops-age-key";
  };
}
