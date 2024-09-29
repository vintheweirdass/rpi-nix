{ config, lib, pkgs, ... }:
{
  hardware.enableRedistributableFirmware = false;
  networking.firewall.enable = false;
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
  networking = {
    networkmanager.enable = true;
    hostName = "rpinix";
  };
  # can be deadly, whatchout
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
}
