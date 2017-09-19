{ config, lib, pkgs, defconfig }:

pkgs.buildUBoot {
  version = "master";
  src = pkgs.fetchgit {
    url = "git://git.denx.de/u-boot-sunxi.git";
    rev = "a438f105241615d756c480015b213ee8859ee7bc";
    sha256 = "ecf54f241cb825490de957d2a10503978176b4023196fc33f8cb88bd14454e58";
  };
  patches = [
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-missing-gpio-compatibles.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-nanopineoplus2.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/add-pinebook-defconfig.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/disable-usb-keyboards.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/enable-DT-overlays-support.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/fix-sopine-defconfig.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/pll1-clock-fix-h5.patch"
    "${pkgs.armbian}/patch/u-boot/u-boot-sun50i-dev/sunxi-boot-splash.patch"
  ];
  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];
  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';
  preBuild = "cp ${pkgs.bl31-a64} bl31.bin";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.itb" "spl/sunxi-spl.bin" ];
  inherit defconfig;
}
