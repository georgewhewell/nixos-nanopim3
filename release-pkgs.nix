{ supportedSystems ? [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ] }:

let
  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: import pkgs/overlay.nix { inherit self super; })
      (self: super: import pkgs/top-level.nix { pkgs = self; })
    ];
  };
  hardware = import ./hardware { inherit pkgs; };
  forAllSystems = pkgs.lib.genAttrs supportedSystems;
  buildPackages = pkg: forAllSystems (system: pkgs.lib.hydraJob (pkg system));
in (
  (import ./pkgs/overlay.nix { self = pkgs; super = pkgs; }) //
  (import ./pkgs/top-level.nix { inherit pkgs; })
)
