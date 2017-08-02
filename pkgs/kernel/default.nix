{ pkgs, ... }:

with pkgs;

let
  linux-amlogic = callPackage ./linux-amlogic.nix { };
  linux-nanopi-m3 = callPackage ./linux-nanopi-m3.nix { };
  linux-sunxi = callPackage ./linux-sunxi.nix { };
in {
  linuxPackages_amlogic = recurseIntoAttrs (linuxPackagesFor linux-amlogic);
  linuxPackages_nanopi-m3 = recurseIntoAttrs (linuxPackagesFor linux-nanopi-m3);
  linuxPackages_sunxi = recurseIntoAttrs (linuxPackagesFor linux-sunxi);
}
