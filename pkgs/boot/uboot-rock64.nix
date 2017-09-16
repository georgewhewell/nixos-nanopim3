{ config, lib, pkgs }:

pkgs.buildUBoot rec {
  src = pkgs.fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-u-boot";
    rev = "22993de62028712e51b11bbd5a4a0ccba70354eb";
    sha256 = "0ikp9wxsrngf46mz6jfgbqcfmp4kfanizihw1jvn4kpyyd5csfv8";
  };

  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];

  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';

  defconfig = "rock64-rk3328_defconfig";

  preBuild = "cp ${pkgs.atf-rockchip} bl31.bin";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "idbloader.bin" "uboot.img" "trust.bin" ];
}
