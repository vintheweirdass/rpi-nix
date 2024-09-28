{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
        pkgs.openssh
        pkgs.firefox
        #so u can run that shit (vcgencmd)
        pkgs.libraspberrypi
        pkgs.neovim
        pkgs.deno
        pkgs.zsh
        pkgs.devenv
        pkgs.flox
  ];

  services.openssh.enable = true;
}