{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="git";
    name = "sunxi-tools-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "linux-sunxi";
      repo = "sunxi-tools";
      rev = "cd9e6099e8668f4aa25d3ffc71283c0b138af1b7";
      sha256 = "12sp4qrhqpch8ijlikjmxnjvisbss90r1wd7q3sdm64wwwsyxd9s";
    };
    buildPhase = "make";
    hardeningDisable = [ "all" ];

    patches = [
      ../../patches/sunxi-tools-crc.patch
    ];

    nativeBuildInputs = [ pkgs.zlib pkgs.binutils pkgs.openssl pkgs.libusb pkgs.pkgconfig ];
    installPhase = ''
      mkdir -p $out/bin
      cp bin2fex fex2bin sunxi-bootinfo sunxi-fel sunxi-fexc sunxi-nand-part sunxi-pio $out/bin
    '';
}
