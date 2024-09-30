{
  description = "KDE Plasma 6 + Programming language tools + RPi4. MADE BY CUPGLASSDEV";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, ... }:
  {
    nixosModules = {
      system = {
        disabledModules = [
          "profiles/base.nix"
        ];
        
        system.stateVersion = "23.11";
      };  
      networking = {
        networkmanager.enable = true;
        hostName = "rpinix";
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
      services.xserver.enable = true;
      services.xserver.displayManager.sddm.enable = true;
      # TODO: delete that fucking 'xserver' on 24.05 and onwards
      services.xserver.desktopManager.plasma6.enable = true;
      programs.sway.enable = true;
      hardware = {
        # not for now
        # raspberry-pi."4".fkms-3d.enable = true;
        # the newer nix do not include this shit again, so i will stick to a package

        # stupid, only works on compute model
        # boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];

        # if you switched to gnome, this prob works. not really tied to hardware tho
        pulseaudio.enable = true;
      };
    };  
    # Normal desktop variant
    packages.aarch64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          ./extra.conf.nix
          ./apps.conf.nix
          nixos-hardware.nixosModules.raspberry-pi-4
          #collection of shits
          self.nixosModules.hardware
          self.nixosModules.system
          self.nixosModules.users
          self.nixosModules.programs
          self.nixosModules.services
          self.nixosModules.networking
        ];
      };
    };
  };
}
