{ stableBranch ? false,
  supportedSystems ? [ "aarch64-linux" "armv7l-linux" "x86_64-linux" ],
  nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
}:

let
  pkgs = import <nixpkgs> { overlays = [
    (self: super: import pkgs/overlay.nix { inherit self super; })
    (self: super: import pkgs/top-level.nix { pkgs = self; })
  ]; };
  lib = pkgs.lib;
  hardware = import ./hardware { inherit pkgs; };
  versionSuffix =
    (if stableBranch then "." else "pre") + "${toString nixpkgs.revCount}.${nixpkgs.shortRev}";
  versionModule =
    { system.nixosVersionSuffix = versionSuffix;
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };

  xzImage = config:
    with config.system;
    pkgs.runCommand "sd-image" { }
    ''
      mkdir -p $out/{img,closure,nix-support}
      ${pkgs.xz}/bin/xz -c -9 ${build.sdImage} > $out/img/${build.sdImage.name}.xz
      ln -s ${build.toplevel} $out/closure/top-level.closure
      echo "file sd-image $out/img/${build.sdImage.name}.xz" >> $out/nix-support/hydra-build-products
      echo "file closure $out/closure/top-level.closure" >> $out/nix-support/hydra-build-products
    '';

  usbLoader = config:
    config.system.build.usb.loader {
      inherit pkgs config;
    };

  getConfig = { system, modules }:
    (import <nixpkgs/nixos/lib/eval-config.nix> {
      inherit system modules;
    }).config;

  buildInstallerConfig = board: system: getConfig {
    inherit system;
    modules = [ board ./profiles/minimal.nix ./profiles/buildfarm.nix ./pkgs/modules/sd-image.nix versionModule ];
  };

  buildNetbootConfig = board: system: getConfig {
    inherit system;
    modules = [ board ./profiles/minimal.nix ./profiles/buildfarm.nix ./pkgs/modules/netboot.nix versionModule ];
  };

  board_conf = board_name: hardware.boards.${board_name};
  board_names = lib.attrNames hardware.boards;

  getPlatforms = board_name:
    (import (board_conf board_name) { inherit pkgs lib; }).meta.platforms;
in lib.genAttrs board_names (board_name:
  let
    platforms = getPlatforms board_name;
  in lib.genAttrs platforms (platform:
    let
      board = board_conf board_name;
      installer-config = (buildInstallerConfig board platform);
      netboot-config = (buildNetbootConfig board platform);
    in {
      sd-image = xzImage installer-config;
      usb-loader = usbLoader netboot-config;
    }
  )
)
