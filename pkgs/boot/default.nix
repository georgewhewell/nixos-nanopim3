{ pkgs, callPackage, ... }:

let
  uboot = { defconfig, filesToInstall, targetPlatforms }: pkgs.buildUBoot rec {
    version = "2017.09";
    src = pkgs.fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "0i4p12ar0zgyxs8hiqgp6p6shvbw4ikkvryd4mh70bppyln5zldj";
    };
    nativeBuildInputs = with pkgs;
      [ gcc bc dtc swig1 which python2 ];
    postPatch = ''
      patchShebangs tools/binman
      patchShebangs lib/libfdt
    '';
    preBuild = pkgs.lib.optional pkgs.stdenv.isAarch64 "cp ${pkgs.bl31-a64} bl31.bin";
    inherit defconfig filesToInstall targetPlatforms;
  };
  uboot-64 = { defconfig, filesToInstall }: uboot {
    inherit defconfig filesToInstall;
    targetPlatforms = [ "aarch64-linux" ];
  };
  uboot-32 = { defconfig, filesToInstall ? [ "u-boot-sunxi-with-spl.bin" ] }: uboot {
    inherit defconfig filesToInstall;
    targetPlatforms = [ "armv7l-linux" ];
  };
  in
{
  atf-rockchip = callPackage ./atf-rockchip.nix { };
  bl1-nanopi-m3 = callPackage ./bl1-nanopi-m3.nix { };
  nanopi-load = callPackage ./nanopi-load.nix { };
  meson-tools = callPackage ./meson-tools.nix { };
  sunxi-tools = callPackage ./sunxi-tools.nix { };
  uboot-odroid-c2 = uboot-64 {
    defconfig = "odroid-c2_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-orangepi-zero = uboot-32 { defconfig = "orangepi_zero_defconfig"; };
  uboot-orangepi-plus2e = uboot-32 { defconfig = "orangepi_plus2e_defconfig"; };
  uboot-nanopi-neo = uboot-32 { defconfig = "nanopi_neo_defconfig"; };
  uboot-nanopi-air = uboot-32 { defconfig = "nanopi_neo_air_defconfig"; };
  uboot-raspberrypi-2b = uboot-32 {
    defconfig = "rpi_2_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-rock64 = callPackage ./uboot-rock64.nix { };
  uboot-nanopi-m3 = callPackage ./uboot-nanopi-m3.nix { };
  uboot-orangepi-pc2 = uboot-64 {
    defconfig = "orangepi_pc2_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };
  uboot-orangepi-prime = uboot-64 {
    defconfig = "orangepi_prime_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };
  uboot-nanopi-neo2 = uboot-64 {
    defconfig = "nanopi_neo2_defconfig"; filesToInstall = [ "spl/sunxi-spl.bin" "u-boot.itb" ]; };

  fip_create = callPackage ./fip-create.nix { };
  bsp-h5-lichee = callPackage ./bsp-h5-lichee.nix { };
  bl1-odroid-c2 = callPackage ./bl1-odroid-c2.nix { };
  bl31-a64 = callPackage ./bl31-a64.nix { };
}
