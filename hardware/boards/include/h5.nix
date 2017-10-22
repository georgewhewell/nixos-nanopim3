{ config, pkgs, lib, ... }:

with lib;
let
  platforms = (import ../../platforms.nix);
in
{
  imports = [
    ./allwinner-boot.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  boot.extraTTYs = [ "ttyS0" ];
  nixpkgs.config.platform = platforms.aarch64-multiplatform;

  system.build.usb = {

    netboot-binaries = pkgs.symlinkJoin {
      name = "netboot";

      paths = with config.system; [
        build.initialRamdisk
        build.kernel
        build.bootloader
      ];

      postBuild = ''
        ${pkgs.ubootTools}/bin/mkimage -A arm64 -d $out/sunxi-spl.bin \
          -f $out/u-boot.its $out/u-boot-sunxi-with-spl.bin
        ${pkgs.ubootTools}/bin/mkimage -A arm64 -T ramdisk -C none -d $out/zImage $out/uImage
        ${pkgs.ubootTools}/bin/mkimage -A arm64 -T ramdisk -C none -d $out/initrd $out/uInitrd
      '';

    };

    loader = { pkgs, config }:
      with config.system;
        let
          bootEnv = pkgs.writeText "bootenv.txt" ''
            #=uEnv
            bootargs=init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
            bootcmd=bootz 0x42000000 0x43300000 0x43000000
        ''; in
        pkgs.writeScriptBin "boot.sh" ''

          # cycle usb hub
          if [[ $1 == "cycle" ]] ; then
            ${pkgs.uhubctl}/bin/uhubctl -a 0
          fi

          # include stuff
          ${pkgs.sunxi-tools}/bin/sunxi-fel -p \
            uboot ${build.usb.netboot-binaries}/u-boot-sunxi-with-spl.bin \
            write 0x42000000 ${build.usb.netboot-binaries}/uImage \
            write 0x43000000 ${build.usb.netboot-binaries}/dtbs/${build.dtbName} \
            write 0x43300000 ${build.usb.netboot-binaries}/uInitrd \
            write 0x43100000 ${bootEnv}
      '';

  };
}
