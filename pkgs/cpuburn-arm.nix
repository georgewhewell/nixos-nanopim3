{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation {
  name = "cpuburn-arm";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "ssvb";
    repo = "cpuburn-arm";
    rev = "ad7e646700d14b81413297bda02fb7fe96613c3f";
    sha256 = "06z3akmlw7b16pvskq4ryl7mq6jndfb9r61gwhqdf1iiqvljv4hk";
  };

  buildPhase = ''
    # compiles under both
    gcc -o cpuburn-a53 cpuburn-a53.S
  '' + (if stdenv.isAarch64 then ''
    # none?
  '' else ''
    # armv7l
    gcc -o cpuburn-a7 cpuburn-a7.S
    gcc -o cpuburn-a8 cpuburn-a8.S
    gcc -o cpuburn-a9 cpuburn-a9.S
    gcc -o cpuburn-krait cpuburn-krait.S
  '');

  installPhase = ''
    mkdir -p $out/bin
    cp -v cpuburn-* $out/bin/
  '';

  meta = {
    description = "A collection of cpuburn programs tuned for different ARM hardware";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    platforms = [ "armv7l-linux" "aarch64-linux" ];
  };

}
