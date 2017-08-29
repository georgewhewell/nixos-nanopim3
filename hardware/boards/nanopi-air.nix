{ config, lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-nanopi-air}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.kernelParams = [ "earlyprintk" "console=ttyS0,115200n8" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];

  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;
  hardware.firmware = [ pkgs.ap6212-firmware ];

  networking.hostName = "nanopi-air";

}
