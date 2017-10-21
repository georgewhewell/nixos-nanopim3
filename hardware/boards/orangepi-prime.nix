{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/h5.nix
  ];

  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-sunxi;
  system.build.bootloader = pkgs.uboot-orangepi-prime;
  system.build.dtbName = "sun50i-h5-orangepi-prime.dtb";

  hardware.firmware = with pkgs; [
    rtl8723bs-firmware
  ];

  networking.hostName = "orangepi-prime";
  meta = {
    platforms = [ "aarch64-linux" ];
  };
}
