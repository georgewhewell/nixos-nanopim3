{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl1-nanopi-m3-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "rafaello7";
      repo = "bl1-nanopi-m3";
      rev = "d65910ab6c510dc47a23e21e99262f4d5b468cea";
      sha256 = "0qhz2vpm3mcdf0n3z3gibqavhpghasiy8z6p6dd670l8ya69vhnm";
    };

    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.binutils ];

    patches = [
     ../../patches/no-stack-protect.patch
     ../../patches/undefined-stuff.patch
     ../../patches/objcopy.patch
    ];

    buildPhase = ''
      make CROSS_TOOL=${pkgs.gcc}/bin/ OBJCOPY=${pkgs.binutils}/bin/objcopy
    '';

    installPhase = ''
      cp out/bl1-drone.bin $out
    '';
}
