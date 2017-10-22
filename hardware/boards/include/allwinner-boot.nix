{ config, pkgs, ... }:

rec {

  system.build.sd = {

    installBootloader = ''
      dd if=${system.build.bootloader}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
    '';

  };

  boot.kernelParams = [ "ignore_loglevel" "boot.shell_on_fail" "console=ttyS0,115200" ];
  boot.initrd.availableKernelModules = [ "usb_f_rndis" "usb_f_acm" "u_ether" "u_serial" "sunxi" "wire" "squashfs" "musb_hdrc" ];

  system.build.usb = {

    netboot-binaries = pkgs.symlinkJoin {
      name = "netboot";

      paths = with config.system;
        let
          bootEnv = pkgs.writeTextDir "bootenv.txt" ''
            #=uEnv
            bootargs=init=${build.toplevel}/init ${toString config.boot.kernelParams}
            bootcmd=bootz 0x42000000 0x43300000 0x43000000
        ''; in [
        build.initialRamdisk
        build.kernel
        build.bootloader
        bootEnv
      ];

      postBuild = ''
        ${pkgs.ubootTools}/bin/mkimage -A arm -T ramdisk -C none -d $out/initrd $out/uInitrd
      '';

    };

    loader = { pkgs, config }:
      with config.system;
        pkgs.writeScriptBin "boot-${config.networking.hostName}.sh" ''

          # include stuff
          ${pkgs.sunxi-tools}/bin/sunxi-fel -p \
            uboot ${build.usb.netboot-binaries}/u-boot-sunxi-with-spl.bin \
            write 0x42000000 ${build.usb.netboot-binaries}/zImage \
            write 0x43000000 ${build.usb.netboot-binaries}/dtbs/${build.dtbName} \
            write 0x43100000 ${build.usb.netboot-binaries}/bootenv.txt \
            write 0x43300000 ${build.usb.netboot-binaries}/uInitrd
      '';

  };

}
