{ supportedSystems ? [ "aarch64-linux" "armv7l-linux" ] }:

let
  pkgs = import <nixpkgs> { };
  hardware = import ./hardware { inherit pkgs; };
  crossBuild = crossSystem: let
    crossPkgs = import pkgs.path {
      inherit crossSystem;
      overlays = [
        (self: super: import pkgs/overlay.nix { inherit self super; })
        (self: super: import pkgs/top-level.nix { pkgs = self; })
      ];
    };
    in import ./pkgs/top-level.nix { pkgs = crossPkgs; };
in rec {
  aarch64Pkgs = (crossBuild hardware.systems.aarch64-multiplatform);
  armv7l-linux = (crossBuild hardware.systems.armv7l-hf-multiplatform);
}
