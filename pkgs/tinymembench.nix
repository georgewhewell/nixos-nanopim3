{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation {
  name = "tinymembench";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "ssvb";
    repo = "tinymembench";
    rev = "a2cf6d7e382e3aea1eb39173174d9fa28cad15f3";
    sha256 = "0c1hjfhj7hhx2gdck3bppp5h9iqc10xz83prxss0y073xv52zn10";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -v tinymembench $out/bin/
  '';

  meta = {
    description = "Simple benchmark for memory throughput and latency";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    platforms = [ "armv7l-linux" "aarch64-linux" ];
  };

}
