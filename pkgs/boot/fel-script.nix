{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "boot-booter-${binaries.name}";

  src = pkgs.writeScriptBin "boot.sh" ''
    # Load kernel
    sunxi-fel -p \
      uboot ${binaries}/u-boot-sunxi-with-spl.bin \
      write 0x42000000 ${binaries}/zImage \
      write 0x43000000 ${binaries}/dtbs/sun8i-h2-plus-orangepi-zero.dtb \
      write 0x43100000 ${binaries}/bootenv.txt \
      write 0x43300000 ${binaries}/uInitrd
  '';

  installPhase = ''
    cp -rv $src $out
  '';

  propagatedBuildInputs = with pkgs; [
    sunxi-tools binaries
  ];

}
