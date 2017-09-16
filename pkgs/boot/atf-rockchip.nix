{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl31-rockchip-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "rockchip-linux";
      repo = "arm-trusted-firmware";
      rev = "1cde9b94fad9b778688cfec478b6d1b9f162b146";
      sha256 = "00rl6m249dvfc53qhjbdmgfj1ci3qrf9q9frgq6kw8fv35l72mha";
    };

    dontStrip = true;
    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.gcc7 ];

    buildPhase = ''
      make PLAT=rk3328 DEBUG=1 bl31
    '';

    installPhase = ''
      cp build/rk3328/debug/bl31.bin $out
    '';
}
