{ config, pkgs, ... }:

{

  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/otg-role.nix
  ];

  system.build.sd = rec {
    installBootloader = "";
  };

  system.build.usb = {
    netboot-binaries = pkgs.symlinkJoin {
      name = "qemu-boot";
      paths = with config.system; [
        build.initialRamdisk
        build.kernel
      ];
    };

    loader = { pkgs, config }:
      with config.system;
        pkgs.writeScriptBin "boot.sh" ''
          ${pkgs.qemu}/bin/qemu-system-arm \
            -machine virt \
            -kernel ${build.usb.netboot-binaries}/zImage \
            -initrd ${build.usb.netboot-binaries}/initrd
      '';
  };

  meta = {
    platforms = [ "aarch64-linux" "armv7l-linux" ];
  };

}
