{ pkgs, ... }:

rec {

  system.build.sd = {
    installBootloader = ''
      dd if=u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
    '';
  };

  system.build.usb = {

    copyBinaries = ''
      echo "file bootenv.txt $out/bootenv.txt" >> $out/nix-support/hydra-build-products
      echo "file zImage $out/zImage" >> $out/nix-support/hydra-build-products
      echo "file u-boot-sunxi-with-spl.bin $out/u-boot-sunxi-with-spl.bin" >> $out/nix-support/hydra-build-products
    '';

    loader = { pkgs, config }:
      with config.system;
      let
        bootEnv = pkgs.writeTextDir "bootenv.txt" ''
          #=uEnv
          bootargs=init=${build.toplevel}/init ${toString config.boot.kernelParams}
          bootcmd=bootz 0x42000000 0x43300000 0x43000000
        '';
      in
        pkgs.writeScriptBin "boot-${config.networking.hostName}.sh" ''

          # include stuff
          ${pkgs.sunxi-tools}/bin/sunxi-fel -p \
            uboot ${build.bootloader}/u-boot-sunxi-with-spl.bin \
            write 0x42000000 ${build.kernel}/zImage \
            write 0x43000000 ${build.kernel}/dtbs/${build.dtbName} \
            write 0x43100000 ${bootEnv}/bootenv.txt \
            write 0x43300000 ${build.initialRamdisk}/uInitrd
      '';

  };

}
