{ pkgs, ... }:

{

  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/h3.nix
  ];

  system.build.bootloader = pkgs.uboot-orangepi-zero;
  system.build.dtbName = "sun8i-h2-plus-orangepi-zero.dtb";

  networking.hostName = "orangepi-zero";

  meta = {
    platforms = [ "armv7l-linux" ];
  };

}
