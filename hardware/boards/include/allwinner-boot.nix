{ pkgs, ... }:

rec {

  system.build.sd = {

    installBootloader = ''
      dd if=${system.build.bootloader}/u-boot-sunxi-with-spl.bin conv=notrunc of=$out bs=1024 seek=8
    '';

  };

  system.build.usb = {

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
            write 0x43300000 ${build.uInitrd}
      '';

  };

}
