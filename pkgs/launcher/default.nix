{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "usb-booter-${binaries.name}";
  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/launcher.py $out/bin
  '';

  propagatedBuildInputs = with pkgs; [
    sunxi-tools
    nanopi-load
    binaries
  ];


}
