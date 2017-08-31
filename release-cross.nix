{ supportedSystems ? [ "aarch64-linux" "armv7l-linux" ] }:

let
  pkgs = import <nixpkgs> { };
  hardware = import ./hardware { inherit pkgs; };
  lib = pkgs.lib;
  versionModule =
    { system.nixosVersionSuffix = "-unstable";
      system.nixosRevision = "git";
    };
  makeSdCross =
    { board, profile, system, crossSystem }:

    with
      import <nixpkgs> { inherit crossSystem; };
      lib.hydraJob ((import <nixpkgs/nixos/lib/eval-config.nix> {
        inherit system;
        modules = [
          board
          profile
          versionModule { }
        ];
      }).config.system.build.sdImage );
  armv7l-linux = board: makeSdCross {
    crossSystem = hardware.systems.armv7l-hf-multiplatform;
    system = "armv7l-linux";
    profile = ./profiles/minimal.nix;
    inherit board;
  };
  aarch64-linux = board: makeSdCross {
    crossSystem = hardware.systems.aarch64-multiplatform;
    system = "aarch64-linux";
    profile = ./profiles/minimal.nix;
    inherit board;
  };
in rec {

  # armv7l
  nanopi-neo = armv7l-linux hardware.boards.nanopi-neo;
  /*nanopi-air = armv7l-linux hardware.boards.nanopi-air;
  orangepi-zero = armv7l-linux hardware.boards.orangepi-zero;
  raspberrypi-2b = armv7l-linux hardware.boards.raspberrypi-2b;

  # aarch64
  odroid-c2 = aarch64-linux hardware.boards.odroid-c2;
  nanopi-neo2 = aarch64-linux hardware.boards.nanopi-neo2;
  nanopi-m3 = aarch64-linux hardware.boards.nanopi-m3;
  orangepi-prime = aarch64-linux hardware.boards.orangepi-prime;
  orangepi-pc2 = aarch64-linux hardware.boards.orangepi-pc2;*/

}
