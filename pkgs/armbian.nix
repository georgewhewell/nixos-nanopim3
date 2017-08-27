{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "2017-07";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "v${version}";
    sha256 = "19rxcj25kw6ninr1g34g4m4vlrk224n86qf585b7bk3pyqh6zzv5";
  };

  phases = [ "installPhase" ];
  outputs = [ "src" ];

  installPhase = ''
    mkdir -p $out/src
    cp -r $src src
  '';

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
