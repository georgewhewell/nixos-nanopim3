{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
    version="git";
    name = "bsp-h5-lichee-${version}";

    src = fetchFromGitHub {
      owner = "friendlyarm";
      repo = "h5-lichee";
      rev = "0c7c3d79968037360d747c8f8492f4fd69334948";
      sha256 = "1bvshfa9pa012yzdwapi3nalpgcwmfq7d3n3w3mlr357a6kq64qk";
    };

    buildPhase = ''
      cp -rL $src/lichee/fa_tools ./
      chmod -R +rw fa_tools
      cd fa_tools && make
    '';

    meta = {
      description = "bsp-h5-lichee";
      maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    };

}
