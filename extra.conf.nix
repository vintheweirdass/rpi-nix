{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
}
