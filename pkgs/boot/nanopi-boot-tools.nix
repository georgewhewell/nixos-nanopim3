{ config, lib, pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  version = "1.0";
  name = "nanopi-boot-tools-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "nanopi-boot-tools";
    rev = "v1.0";
    sha256 = "03i9nlrm7gl9fmj7a9izga15lf9y66xqbqva5zpcc6z2338z2piw";
  };

  installPhase = ''
     mkdir -p $out/bin
     mv nano-ubootenv nano-blembed $out/bin/
  '';

 }
