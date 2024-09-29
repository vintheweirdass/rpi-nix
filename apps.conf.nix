{ config, lib, pkgs, ... }:
let
  rev = "master"; # 'rev' could be a git rev, to pin the overlay.
  waylandOverlay = (import "${builtins.fetchTarball {
    url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz"; 
    #1. Set sha to "", then see the error, get the 'got' key, then done
    sha256 = "09qlbz46fpkw3x3g03rp3sn9yk0mgghal6wlrmrmfqhqg700b8s8";
  }}/overlay.nix");
in
  {
    nixpkgs.overlays = [ waylandOverlay;
      # Workaround: https://github.com/NixOS/nixpkgs/issues/154163
      # modprobe: FATAL: Module sun4i-drm not found in directory
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // {allowMissing = true;});
      }); ];
    environment.systemPackages = with pkgs; [
        wayvnc
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
  }
