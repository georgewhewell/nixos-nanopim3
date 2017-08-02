{ config, lib, pkgs }:

stdenv.mkDerivation {
  version="2015.01";
  name = "fip_create-${version}";
  src = pkgs.uboot-hardkernel.src;
  buildPhase = ''
    cd tools/fip_create/fip_create
    make
  '';
  installPhase = ''
    mkdir -p $out/bin;
    cp tools/fip_create/fip_create/fip_create $out/bin/
  '';
}
