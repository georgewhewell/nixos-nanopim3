{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "usb-booter-${binaries.name}";

  src = pkgs.writeTextDir "boot.sh" ''
    # Load kernel
    ${pkgs.sunxi-tools}/bin/sunxi-fel -p \
      uboot ${binaries}/u-boot-sunxi-with-spl.bin \
      write 0x42000000 ${binaries}/uImage \
      write 0x43000000 ${binaries}/dtbs/sun8i-h2-plus-orangepi-zero.dtb \
      write 0x43100000 ${binaries}/boot.cmd \
      write 0x43300000 ${binaries}/initrd
  '';

  installPhase = ''
    cp -rv $src $out
  '';

  propagatedBuildInputs = with pkgs; [
    sunxi-tools binaries
  ];

}
