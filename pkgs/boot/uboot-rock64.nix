{ config, lib, pkgs }:

pkgs.buildUBoot rec {
  src = pkgs.fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "5aef9f737b3138a2484a9141d4ce60ce534f3572";
    sha256 = "16pzqvwffr5vx0rv8m18agshvvlfxg7f0m2p7499yg39cry8qgca";
  };

  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];

  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';

  defconfig = "rock64-rk3328_defconfig";

  preBuild = "cp ${pkgs.rkbin}/rk33/rk3328_bl31_v1.34.bin bl31.bin";
  postBuild = ''
    tools/mkimage -n rk3328 -T rksd -d spl/u-boot-spl.bin idbloader.img
    cat ${pkgs.rkbin}/rk33/rk3328_miniloader_v2.43.bin >> idbloader.img
  '';
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "idbloader.bin" ];
}
