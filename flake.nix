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
        nixos-hardware.nixosModules.raspberry-pi-4
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
        # you need this, right?
        ./idgaf-about-nix-experimental-commands.rpi.nix
        ./general.rpi.nix
         ({pkgs, config, ... }: {
        config = {
          nix.settings = {
            # add binary caches
            trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              #"flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
              
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://nixpkgs-wayland.cachix.org"
              #"https://cache.flox.dev"
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
        ];
        };
      })
      ];
    };
  };
}
