{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
rec {
  imports = [
    ./include/common.nix
    ./include/otg-role.nix
    ./include/h5.nix
  ];

  networking.hostName = "orangepi-pc2";
  system.build.bootloader = pkgs.uboot-orangepi-pc2;

  meta = {
    platforms = [ "aarch64-linux" ];
  };
}
