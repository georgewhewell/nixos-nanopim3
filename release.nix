{ supportedSystems ? [ "aarch64-linux" "armv7l-linux" ] }:

let
  pkgs = import <nixpkgs> { };
  mypkgs = import ./pkgs/top-level.nix { };
  forAllSystems = pkgs.lib.genAttrs supportedSystems;
  hardware = import ./hardware { inherit pkgs; };
  lib = pkgs.lib;
  versionModule =
    { system.nixosVersionSuffix = "-unstable";
      system.nixosRevision = "git";
    };
  makeSdImage =
    { board, profile, system }:

    with
      import <nixpkgs> { inherit system; };

    lib.hydraJob ((import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system;
      modules = [
        board
        profile
        versionModule { }
      ];
    }).config.system.build.sdImage );
  armv7l-linux = board: makeSdImage {
    system = "armv7l-linux";
    profile = ./profiles/minimal.nix;
    inherit board;
  };
  aarch64-linux = board: makeSdImage {
    system = "aarch64-linux";
    profile = ./profiles/minimal.nix;
    inherit board;
  };
in rec {

  # Ensure that all packages used by the minimal NixOS config end up in the channel.
  dummy = forAllSystems (system: pkgs.runCommand "dummy"
    { toplevel = (import <nixpkgs/nixos/lib/eval-config.nix> {
        inherit system;
        modules = [ ./profiles/minimal.nix ];
      }).config.system.build.toplevel;
      preferLocalBuild = true;
    }
    "mkdir $out; ln -s $toplevel $out/dummy");

  # armv7l
  nanopi-neo = armv7l-linux hardware.boards.nanopi-neo;
  nanopi-air = armv7l-linux hardware.boards.nanopi-air;
  orangepi-zero = armv7l-linux hardware.boards.orangepi-zero;
  raspberrypi-2b = armv7l-linux hardware.boards.raspberrypi-2b;

  # aarch64
  odroid-c2 = aarch64-linux hardware.boards.odroid-c2;
  nanopi-neo2 = aarch64-linux hardware.boards.nanopi-neo2;
  nanopi-m3 = aarch64-linux hardware.boards.nanopi-m3;
  orangepi-prime = aarch64-linux hardware.boards.orangepi-prime;
  orangepi-pc2 = aarch64-linux hardware.boards.orangepi-pc2;

}
