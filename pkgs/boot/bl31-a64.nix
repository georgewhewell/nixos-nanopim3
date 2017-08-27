{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl31-a64-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "longsleep";
      repo = "arm-trusted-firmware";
      rev = "3cdc5c3afebeb2f91634f9f90572c202c1ea85f3"; #"allwinner-a64-bsp";
      sha256 = "1zqg3lx97dlmlfp35c2ygv8gy2y85kdnv0y3dac2kvj1vzrm8hbm";
    };

    dontStrip = true;
    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.gcc6 ];

    buildPhase = ''
      make PLAT=sun50iw1p1 DEBUG=1 bl31
    '';

    installPhase = ''
      cp build/sun50iw1p1/debug/bl31.bin $out
    '';
}
