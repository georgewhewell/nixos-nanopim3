{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "e868c5ddfb611cc15cfe0168db4d83666e4537d9";
    sha256 = "0c205hn3vrr146dd1bi6il6rckzxjs99jsngqx8wghv86xkd439x";
  };

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
