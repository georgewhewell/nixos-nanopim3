{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="git";
    name = "sunxi-tools-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "linux-sunxi";
      repo = "sunxi-tools";
      rev = "d9b1d7e7dff1e70fea91a3f259e9e8ac9508de35";
      sha256 = "1bvshfa9pa012yzdwapi3nalpgcwmfq7d3n3w3mlr357a6kq64qk";
    };

    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.binutils pkgs.openssl pkgs.libusb ];

}
