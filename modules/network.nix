{ config, pkgs, ... }:

{
  # networking.useDHCP = false;

  networking.hostName = "baining";
  # head -c 8 /etc/machine-id
  # networking.hostId = "7dc1a3e5";

  services.openssh.enable = true;

  networking.firewall.enable = false;
  
}
