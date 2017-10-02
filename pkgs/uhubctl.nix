{ stdenv, binutils, openssl, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
    version="1.8";
    name = "uhubctl-v${version}";

    src = fetchFromGitHub {
      owner = "mvp";
      repo = "uhubctl";
      rev = "v${version}";
      sha256 = "0pgccfsga426457xbzvf3msapy9fc8mlmbsbmwk0i9prgnvwrm3y";
    };

    nativeBuildInputs = [ pkgs.libusb ];

    buildPhase = ''
      make DESTDIR=$out
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp uhubctl $out/bin/
    '';

    meta = {
      description = "USB hub per-port power control";
      maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    };

}
