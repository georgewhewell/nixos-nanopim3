{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="git";
    name = "sunxi-tools-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "linux-sunxi";
      repo = "sunxi-tools";
      rev = "d9b1d7e7dff1e70fea91a3f259e9e8ac9508de35";
      sha256 = "073s7psjqgvpv8lybjfqicmbwlq9kkznkyivsd0m25v099la5fy0";
    };

    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.binutils pkgs.openssl pkgs.libusb pkgs.pkgconfig ];

    buildPhase = ''
      make all misc
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp bin2fex fex2bin phoenix_info sunxi-bootinfo sunxi-fel sunxi-fexc sunxi-nand-part sunxi-pio $out/bin
    '';

}
