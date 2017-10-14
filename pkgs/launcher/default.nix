{ pkgs, binaries }:

pkgs.stdenv.mkDerivation {
  name = "usb-booter-${binaries.name}";
  /*src = ./.;*/

  unpackPhase =
    let script = pkgs.writeScript "boot.sh" ''
      echo 'Looking for usb device..'
      sunxi-fel ver

      echo 'Loading u-boot'
      sunxi-fel \
        uboot ${binaries}/u-boot.img \
        write 0x42000000 ${binaries}/initrd \
        write 0x4200000 ${binaries}/uImage

      echo 'Loaded'
    '';
    in ''
      cp ${script} boot.sh
    '';

  installPhase = ''
    cp boot.sh $out
  '';

  propagatedBuildInputs = with pkgs; [
    sunxi-tools binaries
  ];

}
