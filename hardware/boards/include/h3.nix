{ config, pkgs, lib, ... }:

with lib;
let
  platforms = (import ../../platforms.nix);
in
{

  system.build.sd = {

    installBootloader = with config.system; ''
      dd if=${build.bootloader}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
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
        ${pkgs.ubootTools}/bin/mkimage -A arm -T ramdisk -C none -d $out/initrd $out/uInitrd
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

          echo "Checking ver"
          ${pkgs.sunxi-tools}/bin/sunxi-fel ver

          # cycle usb hub
          if [[ $1 == "cycle" ]] ; then
            ${pkgs.uhubctl}/bin/uhubctl -a 0
          fi

          # include stuff
          ${pkgs.sunxi-tools}/bin/sunxi-fel -p \
            uboot ${build.usb.netboot-binaries}/u-boot-sunxi-with-spl.bin \
            write-with-progress 0x42000000 ${build.usb.netboot-binaries}/zImage \
            write-with-progress 0x43000000 ${build.usb.netboot-binaries}/dtbs/${build.dtbName} \
            write-with-progress 0x43300000 ${build.usb.netboot-binaries}/uInitrd \
            write-with-progress 0x43100000 ${bootEnv}
      '';

  };

  boot.kernelParams = [ "boot.shell_on_fail" "console=ttyS0,115200" ];
  boot.initrd.availableKernelModules = [
    "usb_f_rndis" "usb_f_acm" "u_ether" "u_serial" "sunxi" "wire" "squashfs" "musb_hdrc" ];

  boot.initrd.kernelModules = [ "w1-gpio" "w1-therm" "sunxi-cir" ];
  boot.extraTTYs = [ "ttyS0" ];
  boot.kernelPackages = mkDefault pkgs.linuxPackages_sunxi-next;

}
