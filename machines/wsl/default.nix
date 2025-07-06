{ lib, pkgs, config, modulesPath, ... }:
with lib;
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../../modules/systemPackages.nix
    ../../modules/network.nix
    # ../../modules/service/jupyter
  ];

  # File system "/boot" is not a FAT EFI System Partition (ESP) file system.
  boot.loader.systemd-boot.enable = false;

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  vital.mainUser = "nixos";

  users.users.nixos.shell = pkgs.fish;
  
  programs.fish.enable = true;

  vital.graphical.enable = false;

  vital.pre-installed.level = 5;

  vital.programs.modern-utils.enable = true;

  wonder.binaryCaches = {
    enable = true;
    nixServe.host = "192.168.110.223";
    nixServe.port = baseParams.ports.nixServerPort;
  };

  wonder.remoteNixBuild = {
    enable = true;
    user = "lxb";
    host = "192.168.110.223";
  };

  wonder.home-manager = {
    enable = true;
    user = "nixos";
    extraImports = [ ../../home/by-user/nix-dev.nix ];
    vscodeServer.enable = false;
    archer = {
      enable = false;
      remote_host = baseParams.hosts.bishop;
      remote_port = 22;
      remote_user = "lxb";
      ssh_key = "/home/nixos/.ssh/id_rsa";
      remote_warehouse_root = "/var/lib/wonder/warehouse";
      local_warehouse_root = "/var/lib/wonder/warehouse";
      ssh_proxy = "";
    };
    sshConfig = {
      enable = false;
      ssh_key = "/home/nixos/.ssh/id_rsa";
    };
  };

  services.printing.enable = lib.mkForce false;

  services.avahi.enable = lib.mkForce false;

  services.blueman.enable = lib.mkForce false;

  nixpkgs.config.allowUnfree = true;

  security.polkit.enable = true;

  system.stateVersion = "23.05";
  # Update nix config
  nix = {
    gc.automatic = lib.mkForce false;
    settings.auto-optimise-store = false;
  };

}
