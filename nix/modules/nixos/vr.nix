{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "vrstart" ''
      export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc"
      exec "$@"
    '')
  ];

  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
  };
}
