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

  nixpkgs.overlays = [
    (self: super: import ../../../pkgs/overlay.nix { inherit self super; })
    (self: super: import ../../../pkgs/top-level.nix { pkgs = self; })
  ];

}
