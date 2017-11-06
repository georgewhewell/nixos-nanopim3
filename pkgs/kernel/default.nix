{ pkgs, ... }:

with pkgs;

rec {
  linux-amlogic = callPackage ./linux-amlogic.nix { };
  linux-nanopi-m3 = callPackage ./linux-nanopi-m3.nix { };
  linux-sunxi = callPackage ./linux-sunxi.nix { };
  linux-sunxi-next = callPackage ./linux-sunxi-next.nix { };
  linux-sunxi-a83t = callPackage ./linux-sunxi-a83t.nix { };
  linux-sunxi64 = callPackage ./linux-sunxi64.nix { };
  linux-4-12 = callPackage ./linux-4_12.nix { };
  linux-pine64 = callPackage ./linux-pine64.nix { };
  linux-rock64 = callPackage ./linux-rock64.nix { };
  linux-xu4 = callPackage ./linux-xu4.nix { };
  linux-fa = callPackage ./linux-fa.nix { };
  linux-meson = callPackage ./linux-meson-gx.nix { };
  linux-x3399 = callPackage ./linux-x3399.nix { };
  linuxPackages_sunxi-next = recurseIntoAttrs (linuxPackagesFor linux-sunxi-next);
  linuxPackages_amlogic = recurseIntoAttrs (linuxPackagesFor linux-amlogic);
  linuxPackages_nanopi-m3 = recurseIntoAttrs (linuxPackagesFor linux-nanopi-m3);
  linuxPackages_4_12 = recurseIntoAttrs (linuxPackagesFor linux-4-12);
  linuxPackages_sunxi = recurseIntoAttrs (linuxPackagesFor linux-sunxi);
  linuxPackages_sunxi64 = recurseIntoAttrs (linuxPackagesFor linux-sunxi64);
  linuxPackages_sunxi_a83t = recurseIntoAttrs (linuxPackagesFor linux-sunxi-a83t);
  linuxPackages_pine64 = recurseIntoAttrs (linuxPackagesFor linux-pine64);
  linuxPackages_rock64 = recurseIntoAttrs (linuxPackagesFor linux-rock64);
  linuxPackages_xu4 = recurseIntoAttrs (linuxPackagesFor linux-xu4);
  linuxPackages_fa = recurseIntoAttrs (linuxPackagesFor linux-fa);
  linuxPackages_meson = recurseIntoAttrs (linuxPackagesFor linux-meson);
  linuxPackages_x3399 = recurseIntoAttrs (linuxPackagesFor linux-x3399);
}
