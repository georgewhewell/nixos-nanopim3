{ lib, pkgs, ... }:

{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/h5.nix
  ];

  networking.hostName = "orangepi-prime";
  system.build.dtbName = "sun50i-h5-orangepi-prime.dtb";
  system.build.bootloader = pkgs.uboot-orangepi-prime;

  hardware.firmware = with pkgs; [
    rtl8723bs-firmware
  ];

  meta = {
    platforms = [ "aarch64-linux" ];
  };
}
