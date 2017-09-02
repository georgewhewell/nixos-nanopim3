{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "x3399-sdk-${version}";
  version = "2017-08";

  src = pkgs.fetchgit {
    url = "https://gitlab.com/9tripod/x3399_linux.git";
    rev = "9fde99501c6f242b680172adae14da04b218ce82";
    sha256 = "0vq7frcb8dq3f10rpc2ybj9fc82lnbvpc81cnsd41bqgpx61v2wr";
  };

  outputs = [ "bin" "uboot" "kernel" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r tools/upgrade_tool $out/bin/upgrade_tools
    cp -r $src/u-boot $uboot
    cp -r $src/kernel $kernel
  '';

  meta = {
    description = "x3399 sdk";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
