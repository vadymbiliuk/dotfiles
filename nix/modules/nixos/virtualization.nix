{ config, pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };
    };
  };

  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    qemu
    OVMF
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    looking-glass-client
    docker-compose
    freerdp3
    netcat-gnu
  ];

  environment.etc."windows-vm/launch.sh" = {
    text = ''
      #!/usr/bin/env bash
      COMPOSE_FILE="$HOME/.config/windows/docker-compose.yml"

      if [ ! -f "$COMPOSE_FILE" ]; then
        echo "Creating Windows VM configuration..."
        mkdir -p "$HOME/.config/windows"
        mkdir -p "$HOME/.windows"
        mkdir -p "$HOME/Windows"
        
        cat << EOF > "$COMPOSE_FILE"
      services:
        windows:
          image: dockurr/windows
          container_name: nixos-windows
          environment:
            VERSION: "11"
            RAM_SIZE: "8G"
            CPU_CORES: "4"
            DISK_SIZE: "64G"
            USERNAME: "docker"
            PASSWORD: "admin"
          devices:
            - /dev/kvm
            - /dev/net/tun
          cap_add:
            - NET_ADMIN
          ports:
            - 8006:8006
            - 3389:3389/tcp
            - 3389:3389/udp
          volumes:
            - \$HOME/.windows:/storage
            - \$HOME/Windows:/shared
          restart: unless-stopped
          stop_grace_period: 2m
      EOF
      fi

      CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' nixos-windows 2>/dev/null)

      if [ "$CONTAINER_STATUS" != "running" ]; then
        echo "Starting Windows VM..."
        docker-compose -f "$COMPOSE_FILE" up -d
        
        echo "Waiting for Windows to be ready..."
        while ! nc -z 127.0.0.1 3389 2>/dev/null; do
          sleep 2
        done
        sleep 3
      fi

      xfreerdp3 /u:"docker" /p:"admin" /v:127.0.0.1:3389 /f /cert:ignore /title:"Windows VM - NixOS"
    '';
    mode = "0755";
  };

  environment.etc."windows-vm/stop.sh" = {
    text = ''
      #!/usr/bin/env bash
      COMPOSE_FILE="$HOME/.config/windows/docker-compose.yml"
      
      if [ -f "$COMPOSE_FILE" ]; then
        echo "Stopping Windows VM..."
        docker-compose -f "$COMPOSE_FILE" down
        echo "Windows VM stopped."
      else
        echo "Windows VM not configured."
      fi
    '';
    mode = "0755";
  };

  environment.etc."windows-vm/status.sh" = {
    text = ''
      #!/usr/bin/env bash
      CONTAINER_STATUS=$(docker inspect --format='{{.State.Status}}' nixos-windows 2>/dev/null)
      
      if [ -z "$CONTAINER_STATUS" ]; then
        echo "Windows VM container not found."
      elif [ "$CONTAINER_STATUS" = "running" ]; then
        echo "Windows VM Status: RUNNING"
        echo "Web interface: http://127.0.0.1:8006"
        echo "RDP available: port 3389"
      else
        echo "Windows VM is stopped (status: $CONTAINER_STATUS)"
      fi
    '';
    mode = "0755";
  };

  environment.etc."applications/windows-vm.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Windows
      Comment=Start Windows VM via Docker and connect with RDP
      Exec=/etc/windows-vm/launch.sh
      Icon=computer
      Terminal=false
      Type=Application
      Categories=System;Virtualization;
      Keywords=windows;vm;virtual;machine;rdp;
    '';
  };
}
