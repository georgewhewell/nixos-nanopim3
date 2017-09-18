{ pkgs, ... }:

{

  armbian = pkgs.callPackage ./armbian.nix { };
  x3399-sdk = pkgs.callPackage ./x3399-sdk.nix { };
  cpuminer-multi = pkgs.callPackage ./cpuminer-multi.nix { };
  ap6212-firmware = pkgs.callPackage ./ap6212-firmware.nix { };

  inherit (pkgs.callPackages ./boot/default.nix { })
    bl1-nanopi-m3
    bl1-odroid-c2
    bl31-a64
    bsp-h5-lichee
    nanopi-load
    meson-tools
    sunxi-tools
    fip_create
    uboot-nanopi-air
    uboot-odroid-c2
    uboot-orangepi-zero
    uboot-orangepi-plus2e
    uboot-nanopi-neo
    uboot-nanopi-m3
    uboot-orangepi-pc2
    uboot-orangepi-prime
    uboot-pine64
    uboot-nanopi-neo2
    uboot-raspberrypi-2b
    uboot-rock64
    rkbin
    atf-rockchip;

  inherit (pkgs.callPackages ./kernel/default.nix { })
    linuxPackages_testing_local
    linuxPackages_amlogic
    linuxPackages_nanopi-m3
    linuxPackages_sunxi32
    linuxPackages_sunxi64
    linuxPackages_rock64
    linux-nanopi-m3
    linux-amlogic
    linux-sunxi32
    linux-sunxi64;

}
