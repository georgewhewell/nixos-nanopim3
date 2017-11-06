{ config, pkgs, lib, ... }:

with lib;
let
  platforms = (import ../../platforms.nix);
in
rec {

  boot.kernelPackages = pkgs.linuxPackages_sunxi64;
  nixpkgs.config.platform = platforms.aarch64-multiplatform;
  boot.extraTTYs = [ "ttyS0" ];

  system.build.sd =
    with config.system; {

    installBootloader = ''
      dd if=${build.bootloader}/sunxi-spl.bin of=$out bs=8k seek=1 conv=notrunc
      dd if=${build.bootloader}/u-boot.itb of=$out bs=8k seek=5 conv=notrunc
    '';

  };

  system.build.usb = {

    netboot-binaries = pkgs.symlinkJoin {
      name = "netboot";

      paths = with config.system; [
        build.initialRamdisk
        build.kernel
        build.bootloader
      ];

      postBuild = ''
        cp -v ${pkgs.bl31-a64} $out/bl31.bin
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
            spl ${build.usb.netboot-binaries}/sunxi-spl.bin \
            uboot ${build.usb.netboot-binaries}/u-boot.itb \
            write 0x42000000 ${build.usb.netboot-binaries}/zImage \
            write 0x43000000 ${build.usb.netboot-binaries}/dtbs/${build.dtbName} \
            write 0x43300000 ${build.usb.netboot-binaries}/uInitrd \
            write 0x43100000 ${bootEnv}
      '';

  };
}
