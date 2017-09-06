{ config, lib, pkgs, ... }:

let
  overrides = {
    "aarch64-linux" = ../../../pkgs/overrides-aarch64.nix;
    "armv7l-linux" = ../../../pkgs/overrides-armv7l.nix;
  };
in {

  imports = [
    ./sd-image.nix
    ../../../pkgs/modules/networkmanager-small.nix
  ];

  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in

    import ../../../pkgs/top-level.nix {
      # call custom packages with overridden set
      pkgs = self // import ../../../pkgs/overrides.nix {
        # call overrides with original package set
        pkgs = self; }; };

}
