{ config, lib, pkgs, ... }:
{
  networking = {
    firewall.enable = false;
    #networkManager.enable = true;
    #hostName = "rpinix";
  };services.samba.enable = lib.mkForce false;
  # TODO: make a separate firewall version and the non-firewall version | networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  #no zfs please
  boot.supportedFilesystems.zfs = lib.mkForce false;

        # fuck uboot, thats the reason why you need to fork a fucking rpi linux fork, and its OPEN SOURCE FOR THAT SPECIFIC RPI DISTRO
        # and now you, maintainers said "we dont want to repeat the problem from the previous rpi" (4b, 3b, and the earlier ones)
        # and still defend to do a fucking plain linux
        # u dumbass need to test it out, not just commenting out, then closing the issue without an hassle
        # (no, im not talking about the stale bot, its litteraly the maintainer itself who closes so many raspberry pi issues on their official github
        # and the issue still ongoing, not solved)

        # and untill now im still suffering from this specific issue https://github.com/NixOS/nixpkgs/issues/173948
        # and this shit https://github.com/NixOS/nixpkgs/issues/173948#issuecomment-1718069205 for the next update

        # whos the raspberry pi nixos-specific maintainer at this point
        #lib.mkForce false;
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
        # TODO: delete that fucking 'xserver' on 24.05 and onwards
        desktopManager.plasma6.enable = true;
      };
      environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        # konsole is ok tho
        # konsole

        # because IT IS, a small arm cpu cannot run this shit on the raspberry pi
        kdenlive 
        oxygen
        ark
        elisa
        gwenview
        okular
        kate
        khelpcenter
        print-manager
        dolphin
        dolphin-plugins
        spectacle
        ffmpegthumbs
      ];
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
