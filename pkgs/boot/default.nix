{ pkgs, callPackage, ... }:

let
  uboot = { defconfig, filesToInstall, targetPlatforms }: pkgs.buildUBoot rec {
    version = "2017.11-rc4";
    src = pkgs.fetchurl {
      url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
      sha256 = "19ssxxy9cq8nm3p1gkcqyg4qy5f13pl38bfh484hckckbabyanx9";
    };
    patches = [
      "${pkgs.armbian}/patch/u-boot/u-boot-sunxi/add-nanopi-duo.patch"
    ];
    nativeBuildInputs = with pkgs;
      [ gcc bc dtc swig1 which python2 ];
    postPatch = ''
      patchShebangs tools/binman
      patchShebangs lib/libfdt
    '';
    preBuild = pkgs.lib.optional pkgs.stdenv.isAarch64 "cp ${pkgs.bl31-a64} bl31.bin";
    inherit defconfig filesToInstall targetPlatforms;
  };
  uboot-64 = { defconfig, filesToInstall ? [ "spl/sunxi-spl.bin" "u-boot.itb" ] }: uboot {
    inherit defconfig filesToInstall;
    targetPlatforms = [ "aarch64-linux" ];
  };
  uboot-32 = { defconfig, filesToInstall ? [ "u-boot-sunxi-with-spl.bin" ] }: uboot {
    inherit defconfig filesToInstall;
    targetPlatforms = [ "armv7l-linux" ];
  };
in
  with pkgs;
{
  atf-rockchip = callPackage ./atf-rockchip.nix { };
  rkbin = callPackage ./rkbin.nix { };
  bl1-nanopi-m3 = let
    bl1-sd = callPackage ./bl1-nanopi-m3.nix { };
    bl1-usb = callPackage ./bl1-nanopi-m3.nix { usbBoot = true; };
  in
    pkgs.runCommand "combine-boot" { } ''
      mkdir $out
      cp ${bl1-sd} $out/bl1-sd.bin
      cp ${bl1-usb} $out/bl1-usb.bin
    '';
  nanopi-load = callPackage ./nanopi-load.nix { };
  nanopi-boot-tools = callPackage ./nanopi-boot-tools.nix { };
  meson-tools = callPackage ./meson-tools.nix { };
  sunxi-tools = callPackage ./sunxi-tools.nix { };
  uboot-licheepi-zero = uboot-32 { defconfig = "LicheePi_Zero_defconfig"; };
  uboot-odroid-c2 = uboot-64 {
    defconfig = "odroid-c2_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-orangepi-zero = uboot-32 { defconfig = "orangepi_zero_defconfig"; };
  uboot-orangepi-plus2e = uboot-32 { defconfig = "orangepi_plus2e_defconfig"; };
  uboot-nanopi-neo = uboot-32 { defconfig = "nanopi_neo_defconfig"; };
  uboot-nanopi-duo = uboot-32 { defconfig = "nanopi_duo_defconfig"; };
  uboot-nanopi-air = uboot-32 { defconfig = "nanopi_neo_air_defconfig"; };
  uboot-nanopi-neo2 = uboot-64 { defconfig = "nanopi_neo2_defconfig"; };
  uboot-nanopi-m3 = callPackage ./uboot-nanopi-m3.nix { };
  uboot-ntc-chippro = uboot-32 {
    defconfig = "CHIP_pro_defconfig";
    filesToInstall = [ "spl/sunxi-spl.bin" "u-boot-dtb.bin" "spl/sunxi-spl-with-ecc.bin" ];
  };
  uboot-bananapi-m3 = uboot-32 {
    defconfig = "Sinovoip_BPI_M3_defconfig"; };
  uboot-raspberrypi-2b = uboot-32 {
    defconfig = "rpi_2_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-rock64 = callPackage ./uboot-rock64.nix { };
  uboot-pine64 = callPackage ./uboot-sunxi.nix { defconfig = "pine64_plus_defconfig"; };
  uboot-orangepi-pc2 = callPackages ./uboot-sunxi.nix { defconfig = "orangepi_pc2_defconfig"; };
  uboot-orangepi-prime = uboot-64 { defconfig = "orangepi_prime_defconfig"; };
  uboot-jetson-tx1 = uboot-64 {
    defconfig = "p2371-2180_defconfig"; filesToInstall = [ "u-boot.bin" ]; };
  uboot-odroid-xu4 = callPackage ./uboot-hardkernel.nix { };
  fip_create = callPackage ./fip-create.nix { };
  bsp-h5-lichee = callPackage ./bsp-h5-lichee.nix { };
  bl1-odroid-c2 = callPackage ./bl1-odroid-c2.nix { };
  bl31-a64 = callPackage ./bl31-a64.nix { };
}
