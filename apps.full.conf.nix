{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
        #so u can run that shit (vcgencmd)
        pkgs.libraspberrypi
        pkgs.i2c-tools
        pkgs.neovim
        pkgs.deno
        pkgs.zsh
        pkgs.devenv
        pkgs.flox
        pkgs.wayvnc
  ];
}
