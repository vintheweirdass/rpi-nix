{ config, lib, pkgs, ... }:
let
  rev = "master"; # 'rev' could be a git rev, to pin the overlay.
  waylandOverlay = (import "${builtins.fetchTarball {
    url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz"; 
    sha256 = "";
  };}/overlay.nix");
in
  {
    nixpkgs.overlays = [ waylandOverlay ];
    environment.systemPackages = with pkgs; [
        wayvnc
        #so u can run that shit (vcgencmd)
        libraspberrypi
        i2c-tools
        neovim
        deno
        zsh
        devenv
        flox
        openssh
    ];
  }
