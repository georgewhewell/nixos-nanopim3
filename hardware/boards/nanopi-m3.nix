{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  nixpkgs.config.writeBootloader = ''
    # Add NISH header to u-boot
    echo "Wrapping u-boot: \
      $(${pkgs.nanopi-load}/bin/nanopi-load \
          -o u-boot-nsih.bin \
          ${pkgs.uboot-nanopi-m3 }/u-boot.bin 0x43bffe00)"

    # Write bootloaders to sd image
    dd conv=notrunc if=${pkgs.bl1-nanopi-m3} of=$out seek=1
    dd conv=notrunc if=u-boot-nsih.bin of=$out seek=64
  '';

  system.build.usb-loader = build:
    pkgs.writeScriptBin "load-nanopi-m3.sh" ''

    # Upload bl1
    nanopi-load -f ${pkgs.bl1-nanopi-m3-usb}

    # Add header
    $(${pkgs.nanopi-load}/bin/nanopi-load \
        -o u-boot-nsih.bin \
        ${pkgs.uboot-nanopi-m3}/u-boot.bin 0x43bffe00)"

    # Upload uboot
    nanopi-load -f -x ${pkgs.uboot-nanopi-m3}/u-boot.bin 0x00000000
  '';

  boot.kernelPackages = pkgs.linuxPackages_nanopi-m3;
  boot.extraTTYs = [ "ttySAC0" ];
  system.build.bootloader = pkgs.uboot-nanopi-m3;

  nixpkgs.config.platform = platforms.aarch64-nanopi-m3;
  hardware.firmware = [
    pkgs.ap6212-firmware
  ];

  networking.hostName = "nanopi-m3";

}
