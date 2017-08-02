{ config, lib, pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  version="master";
  name = "nanopi-load-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "nanopi-load";
    rev = "38783ec3d35fb68c49892a18a04839a9bb285f3b";
    sha256 = "0vz3mllnp1lv76shh80bc38kr2zh3p4p5icxknkqmkw9960n6xic";
  };

  nativeBuildInputs = [ pkgs.libusb pkgs.pkgconfig pkgs.gcc ];
  hardeningDisable = [ "all" ];

  installPhase = ''
     mkdir -p $out/bin
     mv nanopi-load $out/bin/
     echo "testing: $($out/bin/nanopi-load)"
  '';

 }

