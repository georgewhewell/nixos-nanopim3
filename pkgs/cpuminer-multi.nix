{ stdenv, binutils, openssl, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
    version="0.1";
    name = "cpuminer-multi-${version}";

    src = fetchFromGitHub {
      owner = "tpruvot";
      repo = "cpuminer-multi";
      rev = "7495361e34bb11e0c3e2c778312281071208eb55";
      sha256 = "0vsj9hgz0i70icss3i65nybjm30kjq6dn6haidkrpilg1zvfrv78";
    };

    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.autoreconfHook pkgs.gcc7 pkgs.jansson pkgs.curl ];

    configureFlags = "--with-crypto --with-curl";

    preConfigure = ''
      patchShebangs autogen.sh
      ./autogen.sh
    '';

    installPhase = ''
      patchShebangs build.sh
      ./build.sh
      mkdir -p $out/bin
      cp cpuminer $out/bin/cpuminer
    '';

    meta = {
      description = "cpuminer-multi";
      maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    };

}
