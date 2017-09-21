{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc1";
  modDirVersion = "4.14.0-rc1";
  extraMeta.branch = "4.14";

  src = pkgs.fetchgit {
    url = "https://kernel.googlesource.com/pub/scm/linux/kernel/git/khilman/linux-amlogic.git";
    rev = "b42a362e6d10c342004b183defcb9940331b6737";
    sha256 = "1x4760fdr8x6nmlm46qs669i1fah56zdsgpdfpkmbxnfnwzrl15d";
  };
  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
