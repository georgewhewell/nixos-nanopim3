{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "u-boot-nanopi-m3";
    rev = "0bf4d63cd56e9d8f842397186a67851b3bc3befc";
    sha256 = "1cip2znk1zngzf42lsmfdzi0hgwjxwkc8cn48wzrxvqr4iky8q1j";
  };

  installFlags = [ "SPL" ];
  defconfig = "nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
