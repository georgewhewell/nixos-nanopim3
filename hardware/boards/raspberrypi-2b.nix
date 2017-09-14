{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
  overclocksettings = ''
    arm_freq=1100
    core_freq=250
    sdram_freq=500
    over_voltage=4
  '';
in
{
  imports = [
    ./include/common.nix
  ];

  nixpkgs.config.writeBootloader = ''
    cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot .
    cp ${pkgs.uboot-raspberrypi-2b}/u-boot.bin boot/
    echo '$kernel u-boot.bin' > boot/config.txt
    echo '${overclocksettings}' >> boot/config.txt
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;

  networking.hostName = "rasbperrypi-2b";

}
