{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "37433ccc385337b1d02024464af89ad0d02c6f1d";
    sha256 = "171ywhr672j8iw9n3nc99x4nc217n329qjl6zzjr0sj6bax6597r";
  };

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
