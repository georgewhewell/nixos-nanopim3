{ pkgs }:

rec {
  boards = {
    nanopi-air = ./boards/nanopi-air.nix;
    nanopi-m3  = ./boards/nanopi-m3.nix;
    nanopi-neo = ./boards/nanopi-neo.nix;
    nanopi-neo2 = ./boards/nanopi-neo2.nix;
    odroid-c2 = ./boards/odroid-c2.nix;
    orangepi-pc2  = ./boards/orangepi-pc2.nix;
    orangepi-plus2e = ./boards/orangepi-plus2e.nix;
    orangepi-prime = ./boards/orangepi-prime.nix;
    orangepi-zero  = ./boards/orangepi-zero.nix;
    raspberrypi-2b = ./boards/raspberrypi-2b.nix;
  };

  platforms = (import ./platforms.nix { });
  systems = (import ./systems.nix { inherit platforms; });
}
