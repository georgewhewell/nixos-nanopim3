{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "ap6212-sdio.txt";

  src = fetchFromGitHub {
    owner = "friendlyarm";
    repo = "android_hardware_amlogic_wifi";
    rev = "l-amlogic-gx-sync";
    sha256 = "19rxcj25kw6ninr1g34g4m4vlrk224n86qf585b7bk3pyqh6zzv5";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware/brcm
    cp $src/bcm_ampak/config/6212/fw_bcm43438a0.bin $out/lib/firmware/brcm/brcmfmac43430-sdio.bin
    cp $src/bcm_ampak/config/6212/nvram.txt         $out/lib/firmware/brcm/brcmfmac43430-sdio.txt
  '';

  meta = {
    description = "friendlyarm firmware files for AP6212 ";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    /*platforms = [ stdenv.lib.platforms.all ];*/
  };

}
