{ config, lib, pkgs, defconfig, filesToInstall ? [ "u-boot-sunxi-with-spl.bin" ] }:

pkgs.buildUBoot rec {
  version = "2017.09-rc4";
  src = pkgs.fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "0vn55bnzdn9wdjacclvg3pz2lw3s39a5r8s7q2ld1f67di127qpk";
  };
  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];
  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';
  preBuild = lib.optional pkgs.stdenv.isAarch64 "cp ${pkgs.bl31-a64} bl31.bin";
  targetPlatforms = [ "armv7l-linux" "aarch64-linux" ];
  inherit defconfig filesToInstall;
}
