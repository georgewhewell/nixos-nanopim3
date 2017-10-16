{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/h5.nix
  ];

  nixpkgs.config.platform = platforms.aarch64-sunxi;
  system.build.bootloader = pkgs.uboot-pine64;
  networking.hostName = "pine64-pine64";

  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
