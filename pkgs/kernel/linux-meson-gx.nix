{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.0";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "superna9999";
    repo  = "linux";
    # latest HEAD of branch mirror/master @ 25-09-17
    rev = "704f3c8fd86bc84bea587a3bbe4d23fafe8c2f08";
    sha256 = "0yca9r4jj0gpx53qk9g3p7mjfhqwy9bcywlly57nir79jqi0i4w6";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
