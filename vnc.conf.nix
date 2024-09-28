{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = false;
  # TODO: make a separate firewall version and the non-firewall version | networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
}
