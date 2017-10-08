{ stableBranch ? false,
  supportedSystems ? [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ],
  nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
}:

let
  pkgs = import <nixpkgs> { overlays = [
    (self: super: import pkgs/overlay.nix { inherit self super; })
    (self: super: import pkgs/top-level.nix { pkgs = self; })
  ]; };
  overlays = import ./pkgs/overlay.nix { };
  forAllSystems = pkgs.lib.genAttrs supportedSystems;
  hardware = import ./hardware { inherit pkgs; };
  lib = pkgs.lib;
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";
  versionModule =
    { system.nixosVersionSuffix = versionSuffix;
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };
  export-fel-script = build:
    pkgs.writeTextDir "fel-boot.sh" ''
      # Attach device via USB
      sunxi-fel -v

      # Load kernel
      sunxi-fel \
        uboot ${build.bootloader}/bin/uboot u-boot-sunxi-with-spl.bin \
        write 0x42000000 ${build.kernel}/Image \
        write 0x43000000 ${build.kernel}/dtbs/sun8i-h2-plus-nanopi-duo.dtb \
        write 0x43100000 ${build.bootcmd}/boot.cmd \
        write 0x43300000 ${build.initialRamdisk}/initrd
  '';
  export-netboot = system: board:
  let build = (import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system;
      modules = [
        ./pkgs/modules/netboot.nix
        board
        versionModule
      ];
    }).config.system.build;
  in
    pkgs.symlinkJoin {
      name="netboot";
      paths=[
        build.initialRamdisk
        build.kernel
        build.bootloader
        build.bootcmd
        (export-fel-script build)
      ];
      postBuild = ''
        ${pkgs.ubootTools}/bin/mkimage -A arm -O linux -T kernel -C lz4 -d Image $out/uImage
        mkdir -p $out/nix-support
        echo "file u-boot-sunxi-with-spl.bin $out/u-boot-sunxi-with-spl.bin" >> $out/nix-support/hydra-build-products
        echo "file uImage $out/uImage" >> $out/nix-support/hydra-build-products
        echo "file initrd $out/initrd" >> $out/nix-support/hydra-build-products
        echo "file ipxe $out/netboot.ipxe" >> $out/nix-support/hydra-build-products
        find $outdtbs -name 'sun8i-h3-nanopi*.dtb' -exec echo "file $(basename {}) $out/$(basename {})" >> $out/nix-support/hydra-build-products \;
      '';
    };

  exportXzImg = build: pkgs.runCommand "releases" { }
    ''
      mkdir -p $out/{img,closure,nix-support}
      ${pkgs.xz}/bin/xz -c -9 ${build.sdImage} > $out/img/${build.sdImage.name}.xz
      ln -s ${build.toplevel} $out/closure/top-level.closure
      cp ${build.bootloader} $out/
      echo "file sd-image $out/img/${build.sdImage.name}.xz" >> $out/nix-support/hydra-build-products
      echo "file closure $out/closure/top-level.closure" >> $out/nix-support/hydra-build-products
    '';

  buildSystem = { system, modules }:
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system modules;
    }).config.system.build;

  armv7l-linux = board: exportXzImg (buildSystem {
    system = "armv7l-linux";
    modules = [ board ./profiles/minimal.nix ./pkgs/modules/sd-image.nix versionModule ];
  });

  aarch64-linux = board: exportXzImg (buildSystem {
    system = "aarch64-linux";
    modules = [ board ./profiles/minimal.nix ./pkgs/modules/sd-image.nix versionModule ];
  });

in rec {

  qemu-armv7l-netboot = export-netboot "armv7l-linux" hardware.boards.qemu;
  qemu-aarch64 = export-netboot "aarch64-linux" hardware.boards.qemu;

  nanopi-duo-netboot = export-netboot "armv7l-linux" hardware.boards.nanopi-duo;
  nanopi-m3-netboot = export-netboot "aarch64-linux" hardware.boards.nanopi-m3;

  # armv7l
  nanopi-duo = armv7l-linux hardware.boards.nanopi-duo;
  nanopi-neo = armv7l-linux hardware.boards.nanopi-neo;
  nanopi-air = armv7l-linux hardware.boards.nanopi-air;
  orangepi-zero = armv7l-linux hardware.boards.orangepi-zero;
  raspberrypi-2b = armv7l-linux hardware.boards.raspberrypi-2b;
  orangepi-plus2e = armv7l-linux hardware.boards.orangepi-plus2e;
  odroid-hc1 = armv7l-linux hardware.boards.odroid-hc1;

  # aarch64
  jetson-tx1 = aarch64-linux hardware.boards.jetson-tx1;
  odroid-c2 = aarch64-linux hardware.boards.odroid-c2;
  nanopi-neo2 = aarch64-linux hardware.boards.nanopi-neo2;
  nanopi-m3 = aarch64-linux hardware.boards.nanopi-m3;
  orangepi-prime = aarch64-linux hardware.boards.orangepi-prime;
  orangepi-pc2 = aarch64-linux hardware.boards.orangepi-pc2;
  pine64-pine64 = aarch64-linux hardware.boards.pine64-pine64;
  pine64-rock64 = aarch64-linux hardware.boards.pine64-rock64;
  alfawise-h96proplus = aarch64-linux hardware.boards.alfawise-h96proplus;
}
