{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "rkbin";

  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "rkbin";
    rev = "8358e292dcc30713fe4d9a156cea82f9885f87f1";
    sha256 = "1wp0j8dbym3g2h6wzy363fb1wamq6jprdh8c96c49781jal8jhhb";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    cp -r $src $out
  '';

  meta = {
    description = "rkbin firmware ";
    maintainers = [ stdenv.lib.maintainers.georgewhewell ];
    /*platforms = [ stdenv.lib.platforms.all ];*/
  };

}
