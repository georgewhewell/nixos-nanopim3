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

  boot.kernelPackages = pkgs.linuxPackages_nanopi-m3;
  boot.extraTTYs = [ "ttyACM0" ];
  
  nixpkgs.config.platform = {
      name = "nanopi-m3";
      kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
      kernelHeadersBaseConfig = "defconfig";
      kernelBaseConfig = "nanopim3_defconfig";
      kernelArch = "arm64";
      kernelDTB = true;
      kernelAutoModules = true;
      kernelPreferBuiltin = true;
      kernelExtraConfig = ''
         SND n
         BCMDHD n
         ZPOOL y
         Z3FOLD y
         ZSWAP y
         CRYPTO_LZ4HC m

         INFINIBAND n
         DRM_NOUVEAU n
         DRM_AMDGPU n
         IWLWIFI n
      '';
      uboot = null;
      kernelTarget = "Image";
      gcc = {
        arch = "armv8-a";
      };
   };

  hardware.firmware = [
    pkgs.ap6212-firmware
  ];

  networking.hostName = "nanopi-m3";

}
