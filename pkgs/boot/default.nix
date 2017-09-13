{ pkgs, ... }:

with pkgs;

{
  bl1-nanopi-m3 = callPackage ./bl1-nanopi-m3.nix { };
  nanopi-load = callPackage ./nanopi-load.nix { };
  meson-tools = callPackage ./meson-tools.nix { };
  sunxi-tools = callPackage ./sunxi-tools.nix { };
  uboot-odroid-c2 = callPackage ./uboot-mainline.nix {
    defconfig = "odroid-c2_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-orangepi-zero = callPackage ./uboot-mainline.nix { defconfig = "orangepi_zero_defconfig"; };
  uboot-orangepi-plus2e = callPackage ./uboot-mainline.nix { defconfig = "orangepi_plus2e_defconfig"; };
  uboot-nanopi-neo = callPackage ./uboot-mainline.nix { defconfig = "nanopi_neo_defconfig"; };
  uboot-nanopi-air = callPackage ./uboot-mainline.nix { defconfig = "nanopi_neo_air_defconfig"; };
  uboot-nanopi-m3 = callPackage ./uboot-nanopi-m3.nix { };
  uboot-orangepi-pc2 = callPackage ./uboot-mainline.nix {
    defconfig = "orangepi_pc2_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };
  uboot-orangepi-prime = callPackage ./uboot-mainline.nix {
    defconfig = "orangepi_prime_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };
  uboot-nanopi-neo2 = callPackage ./uboot-mainline.nix {
    defconfig = "nanopi_neo2_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };
  fip_create = callPackage ./fip-create.nix { };
  bsp-h5-lichee = callPackage ./bsp-h5-lichee.nix { };
  bl1-odroid-c2 = callPackage ./bl1-odroid-c2.nix { };
  bl31-a64 = callPackage ./bl31-a64.nix { };
}
