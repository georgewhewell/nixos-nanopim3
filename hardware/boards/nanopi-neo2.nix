{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/otg-role.nix
    ./include/h5.nix
  ];

  networking.hostName = "nanopi-neo2";
  system.build.bootloader = pkgs.uboot-nanopi-neo2;

  meta = {
    platforms = [ "aarch64-linux" ];
  };
}
