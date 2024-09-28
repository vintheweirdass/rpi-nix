{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
        pkgs.firefox
        #so u can run that shit (vcgencmd)
        pkgs.libraspberrypi
        pkgs.i2c-tools
        pkgs.neovim
        pkgs.deno
        pkgs.zsh
        pkgs.devenv
        pkgs.flox
  ];
}