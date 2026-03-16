{ config, pkgs, lib, ... }:

let
  claudePlugins = [
    "frontend-design"
    "superpowers"
    "code-review"
    "github"
    "code-simplifier"
    "playwright"
    "security-guidance"
    "pr-review-toolkit"
    "ruby-lsp"
    "clangd-lsp"
    "rust-analyzer-lsp"
  ];

  installScript = pkgs.writeShellScript "install-claude-plugins" ''
    export PATH="${lib.makeBinPath [ pkgs.nodejs ]}:$PATH"
    claude=${config.home.profileDirectory}/bin/claude
    if [ ! -x "$claude" ]; then
      echo "claude-code not found, skipping plugin install"
      exit 0
    fi
    for plugin in ${lib.concatStringsSep " " claudePlugins}; do
      "$claude" plugins install "$plugin" 2>/dev/null || true
    done
  '';
in
{
  home.activation.claudePlugins =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ${installScript}
    '';
}
