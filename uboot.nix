{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
      owner = "rafaello7";
      repo = "u-boot-nanopi-m3";
      rev = "bec6d06d29da2dfe20541d88795adb5d707c2a17";
      sha256 = "08phny3g9q8zv0782a8idc75i8cr4kx9asl636lfz2ipjfjxq52i";
  };

  patches = [ patches/uboot-config.patch ];
  defconfig = "s5p6818_nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
