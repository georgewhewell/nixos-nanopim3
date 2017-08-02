{ pkgs, ... }:

with pkgs;

{
  bl1-nanopi-m3 = callPackage ./bl1-nanopi-m3.nix { };
  nanopi-load = callPackage ./nanopi-load.nix { };
  meson-tools = callPackage ./meson-tools.nix { };
  sunxi-tools = callPackage ./sunxi-tools.nix { };
  uboot-nanopi-m3 = callPackage ./uboot-nanopi-m3.nix { };
  uboot-hardkernel = callPackage ./uboot-hardkernel.nix { };
  fip-create = callPackage ./fip-create.nix { };
}
