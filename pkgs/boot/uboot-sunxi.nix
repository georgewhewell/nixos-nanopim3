{ config, lib, pkgs, defconfig }:

pkgs.buildUBoot {
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "linux-sunxi";
    repo  = "u-boot-sunxi";
    # latest HEAD of branch mirror/master @ 25-09-17
    rev = "1f6049e2501b5c35c61435dbc05ba96743202674";
    sha256 = "0pjimfx7ybj7fz6frgbqy251x35zihd8vz47za06zi06sjvdzssz";
  };

  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];

  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';

  preBuild = lib.optional pkgs.stdenv.isAarch64 "cp ${pkgs.bl31-a64} bl31.bin";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.itb" "spl/sunxi-spl.bin" ];

  inherit defconfig;
}
