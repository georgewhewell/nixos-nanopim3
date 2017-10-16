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
    ./include/h3.nix
  ];

  # clear less space to reduce churn
  nix.gc.options = ''--max-freed "$((5 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';

  system.build.dtbName = "sun8i-h3-orangepi-plus2e.dtb";
  system.build.bootloader = pkgs.uboot-orangepi-plus2e;
  networking.hostName = "orangepi-plus2e";

  meta = {
    platforms = [ "armv7l-linux" ];
  };
}
