{ lib, pkgs, config, modulesPath, ... }:
with lib; {
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../../modules/systemPackages.nix
    ../../modules/network.nix
  ];

  # File system "/boot" is not a FAT EFI System Partition (ESP) file system.
  boot.loader.systemd-boot.enable = false;

  wsl = {
    enable = true;
    defaultUser = "nixos";
    startMenuLaunchers = true;
    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  users.users.nixos.shell = pkgs.fish;

  programs.fish.enable = true;

  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
  # Update nix config
  nix = {
    gc.automatic = lib.mkForce false;
    settings.auto-optimise-store = false;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

}
