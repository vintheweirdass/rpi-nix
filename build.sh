sudo nix build '.#nixosConfigurations.rpi-nix.config.system.build.sdImage' --extra-experimental-features nix-command --extra-experimental-features flakes
