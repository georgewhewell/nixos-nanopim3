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
    (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/boot/)
    cp ${pkgs.ubootRaspberryPi}/u-boot.bin boot/u-boot-rpi.bin
    echo 'kernel u-boot-rpi.bin' > boot/config.txt
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.platform = platforms.armv7l-hf-multiplatform;

  networking.hostName = "rasbperrypi-2b";

}
