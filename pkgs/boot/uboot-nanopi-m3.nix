{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "u-boot-nanopi-m3";
    rev = "3a2619c02f82c70cd0a35949448790c237ff4677";
    sha256 = "1f4v45n1i495waqvsdhq9vv2jx7hbbl6cbhddw1lqrf8q0fl4979";
  };

  patches = [ ../../patches/uboot-config.patch ];
  defconfig = "nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
