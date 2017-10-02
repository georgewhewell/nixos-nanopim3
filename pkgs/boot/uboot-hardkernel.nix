{ config, lib, pkgs }:

pkgs.buildUBoot {
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "hardkernel";
    repo  = "u-boot";
    # latest HEAD of branch mirror/master @ 25-09-17
    rev = "88af53fbcef8386cb4d5f04c19f4b2bcb69e90ca";
    sha256 = "1v4kd01f9rxs68vipyckzc1q4d6hm3in69l9rbzbgzzda6vn8rf6";
  };

  nativeBuildInputs = with pkgs;
    [ gcc bc dtc swig1 which python2 ];

  postPatch = ''
    patchShebangs tools/binman
    patchShebangs lib/libfdt
  '';

  defconfig = "odroid-xu4_defconfig";
  targetPlatforms = [ "armv7l-linux" ];
  filesToInstall = [
    "sd_fuse/bl1.bin.hardkernel"
    "sd_fuse/bl2.bin.hardkernel.720k_uboot"
    "sd_fuse/tzsw.bin.hardkernel"
    "u-boot-dtb.bin"
  ];

}
