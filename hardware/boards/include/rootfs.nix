{ config, pkgs, lib, ... }:

{

  system.build.rootfsImage = import <nixpkgs/nixos/lib/make-ext4-fs.nix> {
    inherit pkgs;
    storePaths = [ config.system.build.toplevel ];
    volumeLabel = "NIXOS_SD";
  };

}
