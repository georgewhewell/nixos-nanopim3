{ pkgs, ... }:

with pkgs;

let
  linux-amlogic = callPackage ./linux-amlogic.nix { };
  linux-nanopi-m3 = callPackage ./linux-nanopi-m3.nix { };
  linux-testing-local = callPackage ./linux-testing.nix { };
  linux-sun50i = callPackage ./linux-sun50i.nix { };
in {
  linuxPackages_amlogic = recurseIntoAttrs (linuxPackagesFor linux-amlogic);
  linuxPackages_nanopi-m3 = recurseIntoAttrs (linuxPackagesFor linux-nanopi-m3);
  linuxPackages_testing_local = recurseIntoAttrs (linuxPackagesFor linux-testing-local);
  linuxPackages_sun50i = recurseIntoAttrs (linuxPackagesFor linux-sun50i);
}
