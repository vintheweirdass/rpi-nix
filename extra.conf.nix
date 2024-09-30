{ config, lib, pkgs, ... }:
{
  networking = {
    firewall.enable = false;
    networkManager.enable = true;
    hostName = "rpinix"
  }
  # TODO: make a separate firewall version and the non-firewall version | networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  #no zfs please
  boot.supportedFilesystems.zfs = lib.mkForce false;
  sdImage.compressImage = false;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
  time.timeZone = "Asia/Jakarta";
  # can be deadly, whatchout
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
  users = {
        #the nix.dev manual is outdated
        #who the hell, who was using a fricking rpi 1??
        #and the newer rpi4 dosent respect sysfs for gpio 
        #users.groups.gpio = {};
        users.cupglassdev = {
              password = "admin";
              shell = pkgs.zsh;
              description = "change this, ok?";
              isNormalUser = true;
              extraGroups = ["wheel" "networkmanager"];
        };
      };
}
