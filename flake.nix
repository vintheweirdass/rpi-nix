{
  description = "KDE Plasma 6 + Programming language tools + RPi4. MADE BY CUPGLASSDEV";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixos-hardware, nixpkgs-wayland, ... }:
  {
    nixosConfigurations.rpi-nix = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
        # you need this, right?
        ./idgaf-about-nix-experimental-commands.rpi.nix

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
        boot.loader.generic-extlinux-compatible.enable = true
        time.timeZone = "Asia/Jakarta";
        system = {
          disabledModules = [
            "profiles/base.nix"
          ];
           system.stateVersion = "24.05"
        }
        fileSystems = {
        "/" = {
          fsType = "ext4";
          device = "/dev/disk/by-uuid/${initial.evaluation.config.sdImage.rootPartitionUUID}";
          # they dont have a built-in rtc, cuh
          options = ["noatime"];
        };
        "/boot" = {
          # nikocado avocado momment
          fsType = "fat32";
          device = "/dev/disk/by-label/${initial.evaluation.config.sdImage.firmwarePartitionName}";
          options = [ "ro" ];
          depends = [ "/" ];
        }
        security = {
          sudo = {
            enable = true;
            wheelNeedsPassword = false;
          };
        }
      hardware = {
        # not for now
        raspberry-pi."4".fkms-3d.enable = true;

        # stupid, only works on compute model
        # boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];

        #if you switched to gnome, this prob works. not really tied to hardware tho
        pulseaudio.enable = true;
      }
      services = {
        xserver.enable = true;
        displayManager.sddm.enable = true;
        # TODO: delete that fucking 'xserver' on 24.05 and onwards
        desktopManager.plasma6.enable = true;
      }
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
       }
         ({pkgs, config, ... }: {
        config = {
          nix.settings = {
            # add binary caches
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://nixpkgs-wayland.cachix.org"
            ];
          };

          # use it as an overlay
          nixpkgs.overlays = [ 
          nixpkgs-wayland.overlay   
          (final: super: {
          makeModulesClosure = x:
          super.makeModulesClosure (x // {allowMissing = true;});
          }) ];
          # kmaillll
          environment.sessionVariables = {
            NIX_PROFILES = "${pkgs.lib.concatStringsSep " " (pkgs.lib.reverseList config.environment.profiles)}";
          };
          environment.systemPackages = with pkgs; [
        #inputs.nixpkgs-wayland.packages.${system}.waybar
        #wayvnc
        #so u can run that shit (vcgencmd)
        libraspberrypi
        raspberrypi-eeprom
        i2c-tools
        neovim
        deno
        zsh
        devenv
        flox
        ];
        };
      })
      ];
    };
  };
}
