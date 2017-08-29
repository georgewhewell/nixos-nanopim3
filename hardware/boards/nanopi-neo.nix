{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
  ];

  nixpkgs.config.writeBootloader = ''
    dd if=${pkgs.uboot-nanopi-neo}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
  '';

  boot.kernelPackages = pkgs.linuxPackages_testing_local;
  boot.kernelParams = [ "earlyprintk" "console=ttyS0,115200n8" "console=tty0" "zswap.enabled=1" "zswap.compressor=lz4" "zswap.max_pool_percent=80" ];
  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;

  networking.hostName = "nanopi-neo";

}
