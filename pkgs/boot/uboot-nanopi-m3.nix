{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "u-boot-nanopi-m3";
    rev = "4431a3b75afb86fad09d0ae42d1dddb82aa11b5e";
    sha256 = "04kdb78lmf1n1pjrpx7vsw07hiy1w65fa2lbxgg9kgxzjz2898jw";
  };

  patches = [ ../../patches/nanopi-m3-uboot-config.patch ];
  installFlags = [ "SPL" ];
  defconfig = "nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
