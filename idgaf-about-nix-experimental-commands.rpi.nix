{ config, lib, pkgs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = { auto-optimise-store = true; };
  };
}
