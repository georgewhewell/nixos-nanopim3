{ pkgs, ... }:

with pkgs;

rec {
  linux-amlogic = callPackage ./linux-amlogic.nix { };
  linux-nanopi-m3 = callPackage ./linux-nanopi-m3.nix { };
  linux-sunxi32 = callPackage ./linux-sunxi32.nix { };
  linux-sunxi64 = callPackage ./linux-sunxi64.nix { };
  linux-testing-local = callPackage ./linux-testing.nix { };
  linux-rock64 = callPackage ./linux-rock64.nix { };
  linux-xu4 = callPackage ./linux-xu4.nix { };
  linux-meson = callPackage ./linux-meson-gx.nix { };
  linuxPackages_amlogic = recurseIntoAttrs (linuxPackagesFor linux-amlogic);
  linuxPackages_nanopi-m3 = recurseIntoAttrs (linuxPackagesFor linux-nanopi-m3);
  linuxPackages_testing_local = recurseIntoAttrs (linuxPackagesFor linux-testing-local);
  linuxPackages_sunxi32 = recurseIntoAttrs (linuxPackagesFor linux-sunxi32);
  linuxPackages_sunxi64 = recurseIntoAttrs (linuxPackagesFor linux-sunxi64);
  linuxPackages_rock64 = recurseIntoAttrs (linuxPackagesFor linux-rock64);
  linuxPackages_xu4 = recurseIntoAttrs (linuxPackagesFor linux-xu4);
  linuxPackages_meson = recurseIntoAttrs (linuxPackagesFor linux-meson);
}
