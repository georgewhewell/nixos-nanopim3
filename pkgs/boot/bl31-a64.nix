{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl31-a64-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "apritzel";
      repo = "arm-trusted-firmware";
      rev = "87e8aedd80e6448a55b2328768d956fcb5f5d410";
      sha256 = "1hnr1123ik840ihvnck8agqm9r79x8hbaq4d4bvn1q9ayd2d5sy0";
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
