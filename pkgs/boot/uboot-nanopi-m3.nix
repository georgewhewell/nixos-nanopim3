{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "u-boot-nanopi-m3";
    rev = "6eec5ce01ac505e6a093d9e0b7db2284ff57a75d";
    sha256 = "0klb3bhxv2mfqf3r1pkkrdk94s9nzlygldp1bqmhx5jg1dhkk1n6";
  };

  patches = [ ../../patches/uboot-config.patch ];
  defconfig = "nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
