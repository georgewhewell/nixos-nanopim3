{ config, lib, pkgs, ... }:

let
  overrides = {
    "aarch64-linux" = ../../../pkgs/overrides-aarch64.nix;
    "armv7l-linux" = ../../../pkgs/overrides-armv7l.nix;
  };
in {

  imports = [
    ../../../pkgs/modules/networkmanager-small.nix
    ../../../pkgs/modules/disnix-small.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.useNetworkd = true;
  services.resolved.dnssec = "false";

  nixpkgs.overlays = [
    (self: super: import ../../../pkgs/overlay.nix { inherit self super; })
    (self: super: import ../../../pkgs/top-level.nix { pkgs = self; })
  ];

}
