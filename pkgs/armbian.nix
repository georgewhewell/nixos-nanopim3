{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "2017-07";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "b21fc4c15f606490b40781886e6d3099db8f1496";
    sha256 = "1wh2x5c66ibi6dvafdmg06zjsb3wdvnp5x8kdd9mj4ig6m4mik3j";
  };

  /*phases = [ "unpackPhase" "installPhase" ];*/
  outputs = [ "dev" ];

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
