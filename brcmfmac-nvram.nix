
{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "brcmfmac43430-sdio.txt";

  src = fetchurl {
    sha256 = "0s9n4nqnnjf4jqgksdmbdcvr6ryrdmbj17h4p7iks9kak3xwf3w2";
    url = "https://github.com/AlexELEC/AlexELEC-AML/raw/master/projects/S812/filesystem/lib/firmware/brcm/nvram_ap6212a.txt";
  };



  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/lib/firmware/brcm
    cp $src $out/lib/firmware/brcm/brcmfmac43430-sdio.txt
  '';

}


