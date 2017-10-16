{ lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in rec {
  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
  ];

  system.build.sd = {
    installBootloader = ''
      # Add NISH header to u-boot
      echo "Wrapping u-boot: \
        $(${pkgs.nanopi-load}/bin/nanopi-load \
            -o u-boot-nsih.bin \
            ${system.build.bootloader}/u-boot.bin 0x43bffe00)"

      # Write bootloaders to sd image
      dd conv=notrunc if=${pkgs.bl1-nanopi-m3} of=$out seek=1
      dd conv=notrunc if=u-boot-nsih.bin of=$out seek=64
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

            $(${pkgs.nanopi-load}/bin/nanopi-load \
                -o u-boot-nsih.bin \
                ${pkgs.uboot-nanopi-m3}/u-boot.bin 0x43bffe00)"

            # Upload uboot
            nanopi-load -f -x ${pkgs.uboot-nanopi-m3}/u-boot.bin 0x00000000

      '';

  };

  boot.extraTTYs = [ "ttySAC0" ];
  boot.kernelPackages = pkgs.linuxPackages_nanopi-m3;
  system.build.bootloader = pkgs.uboot-nanopi-m3;
  nixpkgs.config.platform = platforms.aarch64-nanopi-m3;

  hardware.firmware = [
    pkgs.ap6212-firmware
  ];

  networking.hostName = "nanopi-m3";
  meta = {
    platforms = [ "aarch64-linux" ];
  };

}
