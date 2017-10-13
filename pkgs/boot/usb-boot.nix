{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "usb-booter-${binaries.name}";
  src = pkgs.writeScript "bootScript" ''
    echo test
  '';

  propagatedBuildInputs = with pkgs; [
    sunxi-tools
    nanopi-load
    binaries
  ];


}
