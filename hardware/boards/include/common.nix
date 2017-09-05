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
    # call overrides with original package set
    import ../../../pkgs/overrides.nix { pkgs = super; } //

    # call custom packages with overridden set
    import ../../../pkgs/top-level.nix { pkgs = self; };

}
