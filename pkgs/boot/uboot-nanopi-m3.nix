{ config, lib, pkgs }:

pkgs.buildUBoot rec {

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "u-boot-nanopi-m3";
    rev = "078a36d65df40ab876a3030d1db8274426576e4f";
    sha256 = "0mlq1ndvyncy48rhlpik972lp1za7715v0kkik99l6x3i8l7gxay";
  };

  defconfig = "nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];
  buildFlags = "SPL=1";

  postInstall = ''
    ${pkgs.nanopi-load}/bin/nanopi-load \
      -f \
      -b SD \
      -o $out/u-boot-sd.bin \
        $out/u-boot.bin 0x43bffe00
  '';

}
