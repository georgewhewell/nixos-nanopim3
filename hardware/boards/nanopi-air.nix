{ config, lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/otg-role.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-nanopi-air}/sunxi-spl.bin of=$out bs=8k seek=1 conv=notrunc
    dd if=${pkgs.uboot-nanopi-air}/u-boot.itb of=$out bs=8k seek=5 conv=notrunc
  '';

  boot.extraTTYs = [ "ttyS0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;
  hardware.firmware = [ pkgs.ap6212-firmware ];

  networking.hostName = "nanopi-air";

}
