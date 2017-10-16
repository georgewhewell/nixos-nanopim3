{ lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/h3.nix
  ];

  hardware.firmware = [ pkgs.ap6212-firmware ];
  system.build.bootloader = pkgs.uboot-nanopi-air;
  system.build.dtbName = "sun8i-h3-nanopi-neo-air.dtb";

  networking.hostName = "nanopi-air";

  meta = {
    platforms = [ "armv7l-linux" ];
  };
}
