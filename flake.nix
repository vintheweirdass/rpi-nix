{
  description = "Optional KDE Plasma 6 + Programming language tools + RPi4. MADE BY CUPGLASSDEV";
  inputs = {
    nixosVersion = "23.11";
    nixpkgs.url = "nixpkgs/nixos-23.11";
    homeUser = "cupglassdev";
    password = "admin"; #please change this after importing the repo, or you'll be the idiot
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, nixosVersion, homeUser, password, ... }:
  {
    nixosModules = {
      system = {
        disabledModules = [
          "profiles/base.nix"
        ];

        system.stateVersion = "${nixosVersion}";
      };  
      users = {
        #the nix.dev manual is outdated
        #who the hell, who was using a fricking rpi 1??
        #and the newer rpi4 dosent respect sysfs for gpio 
        #users.groups.gpio = {};
        users.${homeUser} = {
              password = "${password}";
              isNormalUser = true;
              extraGroups = ["wheel"];
        };
      };
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      programs.sway.enable = true;
    };  
    packages.aarch64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          "./apps.conf.nix"
          "./extra.conf.nix"
          self.nixosModules.system
          self.nixosModules.users
          self.nixosModules.programs
          self.nixosModules.services
        ];
      };
    };
    packages.aarch64-linux-ssh = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          "./apps.conf.nix"
          "./extra.conf.nix"
          "./ssh.conf.nix"
          self.nixosModules.system
          self.nixosModules.users
          self.nixosModules.programs
          self.nixosModules.services
        ];
      };
    };
  };
}