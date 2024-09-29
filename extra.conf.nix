{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = false;
  # TODO: make a separate firewall version and the non-firewall version | networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];
  nixpkgs.config.allowUnfree = true;
  #no zfs please
  boot.supportedFilesystems.zfs = lib.mkForce false;
  sdImage.compressImage = false;
  nixpkgs.overlays = [
      # Workaround: https://github.com/NixOS/nixpkgs/issues/154163
      # modprobe: FATAL: Module sun4i-drm not found in directory
      (final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // {allowMissing = true;});
      })
    ];
}
