{ lib, pkgs, ... }:

{
  imports = [
    ./include/common.nix
    ./include/h5.nix
  ];

  system.build.bootloader = pkgs.uboot-pine64;
  networking.hostName = "pine64-pine64";

  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
