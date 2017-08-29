{ config, lib, pkgs, defconfig, filesToInstall ? [ "u-boot-sunxi-with-spl.bin" ] }:

pkgs.buildUBoot rec {
  version = "2017.09-rc2";
  src = pkgs.fetchgit {
    url = "git://git.denx.de/u-boot.git";
    rev = "2d3c4ae350fe8c196698681ab9410733bf9017e0";
    sha256 = "caf42d36570b9b013202cf42ea55705df49c4b1b8ab755afbd8f6324614b1a09";
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
