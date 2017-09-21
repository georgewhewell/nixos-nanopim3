{ pkgs }:

rec {
  boards = {
    jetson-tx1 = ./boards/jetson-tx1.nix;
    nanopi-air = ./boards/nanopi-air.nix;
    nanopi-m3  = ./boards/nanopi-m3.nix;
    nanopi-neo = ./boards/nanopi-neo.nix;
    nanopi-neo2 = ./boards/nanopi-neo2.nix;
    odroid-c2 = ./boards/odroid-c2.nix;
    orangepi-pc2  = ./boards/orangepi-pc2.nix;
    orangepi-plus2e = ./boards/orangepi-plus2e.nix;
    orangepi-prime = ./boards/orangepi-prime.nix;
    orangepi-zero  = ./boards/orangepi-zero.nix;
    pine64-pine64 = ./boards/pine64-pine64.nix;
    pine64-rock64 = ./boards/pine64-rock64.nix;
    raspberrypi-2b = ./boards/raspberrypi-2b.nix;
    qemu = ./boards/qemu.nix;
  };

  platforms = (import ./platforms.nix { });
  systems = (import ./systems.nix { inherit platforms; });
}
