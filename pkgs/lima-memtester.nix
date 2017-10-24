{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation {
  name = "lima-memtester";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "ssvb";
    repo = "lima-memtester";
    rev = "0ded5c6438ebc5ade6d7bae96c7afd9c9f61d492";
    sha256 = "03bpca835flq7qbcj1n5qri8x46jpxqpyk9y1hb4pnx781aalzws";
  };

  buildInputs = [ pkgs.cmake ];

  meta = {
    description = "Memory stress testing tool, implemented by combining http://limadriver.org/ and http://pyropus.ca/software/memtester/";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    platforms = [ "armv7l-linux" "aarch64-linux" ];
  };

}
