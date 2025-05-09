{ config, lib, pkgs, ... }:
{
  networking = {
    firewall.enable = false;
    #networkManager.enable = true;
    #hostName = "rpinix";
  };
  services.samba.enable = lib.mkForce false;
  # TODO: make a separate firewall version and the non-firewall version | networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  #no zfs please
  boot.supportedFilesystems.zfs = lib.mkForce false;

  boot = {
    loader.generic-extlinux-compatible.enable = true;
    kernelParams = [ "console=serial0,115200n8" "console=tty1" ];
  };
  time.timeZone = "Asia/Jakarta";
  disabledModules = [
    "profiles/base.nix"
  ];
  system = {
    stateVersion = "24.05";
  };
  fileSystems = {
    "/" = {
      fsType = "ext4";
      device = "/dev/disk/by-label/NIXOS_SD";
      # they dosent have a built-in rtc, cuh
      options = ["noatime"];
    };
    "/boot" = {
      # nikocado avocado moment
      fsType = "fat32";
      device = "/dev/disk/by-label/BOOT";
      # not gud for nix and the rpi itself, every time it rebuilds, some package will take the boot partition to edit
      # the config.txt
      # options = [ "ro" ];
      depends = [ "/" ];
    };
  };
  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };
  hardware = {
    # not for now
    raspberry-pi."4" = {
      fkms-3d.enable = true;
      # yes, enabled by default since it dosent have any multiple functions to these pins
      i2c1.enable = true;
      # consumes too much power
      # leds.act.enable = true;
      # 'cant find symbol audio', bcs idgaf about jack output. Bluetooth seems to be worth it on headless or desktop
      # audio.enable = true;
      apply-overlays-dtmerge.enable = true;
      # ze bluetooth dewise is ready to paer
      bluetooth.enable = true;
    };
    # stupid, only works on compute model
    # boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];

    #if you switched to gnome, this prob works. not really tied to hardware tho
    #pulseaudio.enable = true;
  };
  services = {
    xserver.enable = true;
    displayManager.sddm.enable = true;
    # Replacing Plasma with LXQt
    desktopManager.lxqt.enable = true;
    # Disable Plasma
    desktopManager.plasma6.enable = false;
  };
  # Remove Plasma packages exclusion since we're not using Plasma anymore
  # environment.plasma6.excludePackages = [];
  
  programs.zsh.enable = true;
  users = {
    #the nix.dev manual is outdated
    #who the hell, who was using a fricking rpi 1??
    #and the newer rpi4 dosent respect sysfs for gpio 
    #users.groups.gpio = {};
    users.cupglassdev = {
      password = "admin";
      shell = pkgs.zsh;
      description = "hi rpi-nix fan!";
      isNormalUser = true;
      # add networkmanager if gnome
      extraGroups = ["wheel" "networkmanager"];
    };
  };
}
