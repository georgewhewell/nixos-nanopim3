{ pkgs, ... }:

with pkgs;

let
  linux-amlogic = callPackage ./linux-amlogic.nix { };
  linux-nanopi-m3 = callPackage ./linux-nanopi-m3.nix { };
  linux-sunxi64 = callPackage ./linux-sunxi64.nix { };
  linux-testing-local = callPackage ./linux-testing.nix { };
in {
  linuxPackages_amlogic = recurseIntoAttrs (linuxPackagesFor linux-amlogic);
  linuxPackages_nanopi-m3 = recurseIntoAttrs (linuxPackagesFor linux-nanopi-m3);
  linuxPackages_testing_local = recurseIntoAttrs (linuxPackagesFor linux-testing-local);
  linuxPackages_sunxi64 = recurseIntoAttrs (linuxPackagesFor linux-sunxi64);
}
