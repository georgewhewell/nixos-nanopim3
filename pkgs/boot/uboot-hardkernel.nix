pkgs.buildUBoot rec {
  version = "2015.01";
  /*name = "odroidc2-"*/

  src = pkgs.fetchFromGitHub {
    owner = "hardkernel";
    repo = "u-boot";
    rev = "odroidc2-v${version}";
    sha256 = "08phny3g9q8zv0782a8idc75i8cr4kx9asl636lfz2ipjfjxq52i";
  };

  defconfig = "s5p6818_nanopim3_defconfig";
  targetPlatforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin" ];

}
