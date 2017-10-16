{ lib, pkgs, ... }:

let
  platforms = (import ../platforms.nix);
in {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  boot.extraTTYs = [ "ttyS0" ];

  hardware.firmware = [ pkgs.ap6212-firmware ];

  networking.hostName = "x3399";

  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
