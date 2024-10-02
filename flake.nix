{
  description = "KDE Plasma 6 + Programming language tools + RPi4. MADE BY CUPGLASSDEV";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, nixpkgs-wayland, ... }:
  {
    nixosModules = {
      system = {
        disabledModules = [
          "profiles/base.nix"
        ];
        
        system.stateVersion = "24.05";
      };  
      # weird, the nix says that the networkmanager isnt exist
      #networking = {
        #networkmanager.enable = true;
      #};
      services = {
        xserver.enable = true;
        displayManager.sddm.enable = true;
      # TODO: delete that fucking 'xserver' on 24.05 and onwards
        desktopManager.plasma6.enable = true;
      };
      # programs.sway.enable = true;
      #hardware = {
        # not for now
        # raspberry-pi."4".fkms-3d.enable = true;
        # the newer nix do not include this shit again, so i will stick to a package

        # stupid, only works on compute model
        # boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];

        # if you switched to gnome, this prob works. not really tied to hardware tho
        # pulseaudio.enable = true;
        # IT DOSENT EXIST TOO??? bye gnome user, i think you will be deaf for now
      #};
    };  
    # Normal desktop variant
    packages.aarch64-linux = {
        sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
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
          ./extra.conf.nix
          nixos-hardware.nixosModules.raspberry-pi-4
          #collection of shits
          #self.nixosModules.hardware
          self.nixosModules.system
          #self.nixosModules.users
          #self.nixosModules.programs
          self.nixosModules.services
          #self.nixosModules.networking
        ];
        };
    };
  };
}
