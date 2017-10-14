{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "usb-booter-${binaries.name}";

  src = pkgs.writeTextDir "boot.sh" ''
    # Attach device via USB
    sunxi-fel -v

    # Load kernel
    sunxi-fel \
      uboot ${binaries}/u-boot-sunxi-with-spl.bin \
      write 0x42000000 ${binaries}/uImage \
      write 0x43000000 ${binaries}/dtbs/sun8i-h2-plus-nanopi-duo.dtb \
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
