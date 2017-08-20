{ stdenv, lib, pkgs }:

stdenv.mkDerivation rec {
  version="2015.01";
  name = "fip_create-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "hardkernel";
    repo = "u-boot";
    rev = "odroidc2-v${version}";
    sha256 = "0yhrq52pga3abs36ij2sgpkzhs9l2wap02dh3sgf5cwrzfc9yf24";
  };

  buildPhase = ''
    cp -rL $src/tools/fip_create ./
    chmod -R +rw fip_create
    cd fip_create && make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv fip_create $out/bin/
  '';

  meta = {
    description = "odroid-c2 fip-create tool";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };
}
