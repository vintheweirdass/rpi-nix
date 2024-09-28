{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = false;
  nixpkgs.config.allowUnfree = true;
}