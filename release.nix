{ supportedSystems ? [ "aarch64-linux" ] }:

let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  versionModule =
    { system.nixosVersionSuffix = "-unstable";
      system.nixosRevision = "git";
    };
  makeSdImage =
    { module, type, system }:

    with import <nixpkgs> { inherit system; };

    lib.hydraJob ((import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system;
      modules = [
        (if type == "graphical" then ./profiles/graphical.nix else ./profiles/minimal.nix)
        module
        versionModule { }
      ];
    }).config.system.build.sdImage );

in rec {

  # AArch64
  odroid-c2-minimal = makeSdImage {
    module = ./boards/odroid-c2/hardware-config.nix;
    type = "minimal";
    system = "aarch64-linux";
  };

  nanopi-m3-minimal = makeSdImage {
    module = ./boards/nanopi-m3/hardware-config.nix;
    type = "minimal";
    system = "aarch64-linux";
  };

  orangepi-prime = makeSdImage {
    module = ./boards/orangepi-prime/hardware-config.nix;
    type = "minimal";
    system = "aarch64-linux";
  };

  orangepi-pc2 = makeSdImage {
    module = ./boards/orangepi-pc2/hardware-config.nix;
    type = "minimal";
    system = "aarch64-linux";
  };

  # Armhf
  nanopi-neo-minimal = makeSdImage {
    module = ./boards/nanopi-neo/hardware-config.nix;
    type = "minimal";
    system = "armv7l-linux";
  };
}
