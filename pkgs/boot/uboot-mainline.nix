{ config, lib, pkgs, defconfig, filesToInstall ? [ "u-boot-sunxi-with-spl.bin" ] }:

pkgs.buildUBoot rec {
  version = "2017.09-rc3";
  src = pkgs.fetchurl {
    url = "ftp://ftp.denx.de/pub/u-boot/u-boot-${version}.tar.bz2";
    sha256 = "0k9r64lx9xajv3zmxassai7l8nxrbcxb5ml6cfghip056a59s9mm";
  };
  nativeBuildInputs = with pkgs;
    [ gcc6 bc dtc swig1 which python2 ];
  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';
  targetPlatforms = [ "armv7l-linux" ];
  inherit defconfig filesToInstall;
}
