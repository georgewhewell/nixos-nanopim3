{ lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/wireless.nix
    ./include/otg-role.nix
    ./include/h3.nix
  ];

  system.build.bootloader = pkgs.uboot-nanopi-duo;
  system.build.dtbName = "sun8i-h2-plus-orangepi-zero.dtb";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_sunxi-next;
  networking.hostName = "nanopi-duo";

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
