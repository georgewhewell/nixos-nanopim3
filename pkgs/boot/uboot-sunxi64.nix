{ config, lib, pkgs, defconfig }:

pkgs.buildUBoot {
  version = "master";
  src = pkgs.fetchFromGitHub {
    owner = "apritzel";
    repo = "u-boot";
    rev = "2d7cb5b426e7e0cdf684d7f8029ad132d7a8d383";
    sha256 = "18dvbmapijq59gaz418pz939r3vwaz6a29m5jlxfacywiggjgyrw";
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
    [ gcc6 bc dtc swig1 which python2 ];
  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';
  preBuild = "cp ${pkgs.bl31-a64} bl31.bin";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.img" "spl/sunxi-spl.bin" ];
  inherit defconfig;
}
