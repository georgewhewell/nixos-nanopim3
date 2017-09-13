{ supportedSystems ? [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ] }:

let
  pkgs = import <nixpkgs> { };
  overlays = import ./pkgs/overlay.nix { };
  mypkgs = import ./pkgs/top-level.nix { };
  forAllSystems = pkgs.lib.genAttrs supportedSystems;
  hardware = import ./hardware { inherit pkgs; };
  lib = pkgs.lib;

  versionModule =
    { system.nixosVersionSuffix = "-unstable";
      system.nixosRevision = "git";
    };

  exportIso = build:
    pkgs.symlinkJoin {
      name="sd-image";
      paths=[
        build.sdImage
      ];
    postBuild = ''
      mkdir -p $out/nix-support
      echo "file sd-image.img $out" >> $out/nix-support/hydra-build-products
    '';
  };

  buildSystem = { system, modules }:
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system modules;
    }).config.system.build;

  armv7l-linux = board: exportIso (buildSystem {
    system = "armv7l-linux";
    modules = [ board ./profiles/minimal.nix versionModule ];
  });

  aarch64-linux = board: exportIso (buildSystem {
    system = "aarch64-linux";
    modules = [ board ./profiles/minimal.nix versionModule ];
  });
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
  orangepi-plus2e = armv7l-linux hardware.boards.orangepi-plus2e;

  # aarch64
  odroid-c2 = aarch64-linux hardware.boards.odroid-c2;
  nanopi-neo2 = aarch64-linux hardware.boards.nanopi-neo2;
  nanopi-m3 = aarch64-linux hardware.boards.nanopi-m3;
  orangepi-prime = aarch64-linux hardware.boards.orangepi-prime;
  orangepi-pc2 = aarch64-linux hardware.boards.orangepi-pc2;

}
