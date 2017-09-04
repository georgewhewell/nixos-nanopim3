{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "2017-07";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "506fa69515c6de4ac0a811d4d986001da61aad13";
    sha256 = "1bmibnhy5b63lwla7h4apdkbfx4rnr9dgaq978gd38p34d4j6dlw";
  };

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
