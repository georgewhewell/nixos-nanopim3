{ config, pkgs, ... }:

rec {

  boot.kernelParams = [
    "ignore_loglevel"
    "boot.shell_on_fail"
    "earlyprintk"
    "console=ttySAC0,115200"
    "initrd=0x49000000,0x3000000"
  ];

  system.build.sd = rec {
    installBootloader = ''
      dd conv=notrunc if=${pkgs.bl1-nanopi-m3}/bl1-sd.bin of=$out seek=1
      dd conv=notrunc if=${pkgs.uboot-nanopi-m3}/u-boot-sd.bin of=$out seek=64
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
        ${pkgs.ubootTools}/bin/mkimage -A arm64 -T ramdisk -C none -d $out/initrd $out/uInitrd
        ${pkgs.ubootTools}/bin/mkimage -A arm64 -T kernel -C none -d $out/Image $out/uImage
        ${pkgs.nanopi-load}/bin/nanopi-load -b USB -o $out/u-boot-nsih.bin $out/u-boot.bin 0x00000000
      '';

    };

    loader = { pkgs, config }:
      with config.system;
      let
        bootEnv = pkgs.writeText "bootenv.txt" ''
          #=uEnv
          bootargs=init=${build.toplevel}/init ${toString config.boot.kernelParams}
          udown_kernel=udown 0x41000000
          udown_initrd=udown 0x45000000
          udown_dtb=udown 0x4c000000
          initrd_high=0xffffffff
          bootcmd2=echo "Starting downloads"; \
            run udown_kernel; \
            run udown_initrd; \
            run udown_dtb; \
            echo "Booting kernel.." \
            booti 0x41000000 0x45000000 0x4c000000
        '';
      in
        pkgs.writeScriptBin "boot-${config.networking.hostName}.sh" ''
            set -e


            echo "uploading bl1"
            ${pkgs.nanopi-load}/bin/nanopi-load -f -x \
              ${build.usb.netboot-binaries}/bl1-usb.bin

            sleep 1

            echo "uploading uboot"
            ${pkgs.nanopi-load}/bin/nanopi-load -f \
              ${build.usb.netboot-binaries}/u-boot.bin 0x43bffe00

            sleep 2

            echo "uploading environment"
            ${pkgs.nanopi-load}/bin/nanopi-load \
              ${bootEnv} 0

            sleep 1
            echo "uploading kernl"
            ${pkgs.nanopi-load}/bin/nanopi-load \
              ${build.usb.netboot-binaries}/Image 0

            sleep 1
            echo "uploading initrd"
            ${pkgs.nanopi-load}/bin/nanopi-load \
              ${build.usb.netboot-binaries}/uInitrd 0

            sleep 1
            echo "uploading dtb"
            ${pkgs.nanopi-load}/bin/nanopi-load \
              ${build.usb.netboot-binaries}/dtbs/nexell/s5p6818-nanopi-m3.dtb 0

      '';

  };

}
