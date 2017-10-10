{ config, lib, pkgs, usbBoot ? false }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl1-nanopi-m3-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "rafaello7";
      repo = "bl1-nanopi-m3";
      rev = "1c4d51ee2964d98844f2b74f2f47a97802aecf91";
      sha256 = "0as9ss43lybaxlqn76jd7a6c8k9lj8hlh8wk34k8bpzdmrx4pdxp";
    };

    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.binutils ];

    patches = [
      ../../patches/objcopy.patch
    ];

    postPatch = lib.optional usbBoot ''
      sed -i -e 's/0x03000000/0x00000000/g' src/startup_aarch64.S
    '';

    buildPhase = ''
      make CROSS_TOOL=${pkgs.gcc}/bin/ OBJCOPY=${pkgs.binutils}/bin/objcopy
    '';

    installPhase = ''
      cp out/bl1-nanopi.bin $out
    '';
}
