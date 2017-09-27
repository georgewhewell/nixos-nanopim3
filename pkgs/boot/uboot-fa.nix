{ config, lib, pkgs, defconfig }:

pkgs.buildUBoot {
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "friendlyarm";
    repo  = "u-boot";
    # latest HEAD of branch sunxi-v2017.x @ 27-09-17
    rev = "2013d886f15cbe78d3806a0168a9c6e432ddd4cf";
    sha256 = "19007jqs4m6q59djchrx1xhm6m4i6w2c9z61p1fqf4zrj7hmq0f3";
  };

  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];

  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';

  targetPlatforms = [ "armv7l-linux" ];
  filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];

  inherit defconfig;
}
