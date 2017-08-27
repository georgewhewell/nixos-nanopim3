{ pkgs, ... }:

with pkgs;

{
  bl1-nanopi-m3 = callPackage ./bl1-nanopi-m3.nix { };
  nanopi-load = callPackage ./nanopi-load.nix { };
  meson-tools = callPackage ./meson-tools.nix { };
  sunxi-tools = callPackage ./sunxi-tools.nix { };
  uboot-nanopi-m3 = callPackage ./uboot-nanopi-m3.nix { };
  fip_create = callPackage ./fip-create.nix { };
  bsp-h5-lichee = callPackage ./bsp-h5-lichee.nix { };
  bl1-odroid-c2 = callPackage ./bl1-odroid-c2.nix { };
  bl31-a64 = callPackage ./bl31-a64.nix { };
}
