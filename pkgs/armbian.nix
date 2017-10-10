{ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "armbian-${version}";
  version = "git";

  src = pkgs.fetchFromGitHub {
    owner = "armbian";
    repo = "build";
    rev = "c37dce800a05e27530587d9e11901265ee0704f0";
    sha256 = "a6b7508342b2467d6969378371e907055bd13048084022f6b3a04a495fc3802b";
  };

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = "cp -r $src $out";

  meta = {
    description = "armbian source";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
  };

}
