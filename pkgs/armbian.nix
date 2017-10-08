{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "40ed0a8a791f31d1b5ff06dfce2acbf08ff4e0fa";
    sha256 = "19m84nf70h01r6y0zgng5b78c8dzk58wvpwwzq8aryvxbp04hp2r";
  };

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
