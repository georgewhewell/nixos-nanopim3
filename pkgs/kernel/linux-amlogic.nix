{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc4";
  modDirVersion = "4.14.0-rc4";
  extraMeta.branch = "4.14";

  src = pkgs.fetchgit {
    url = "https://kernel.googlesource.com/pub/scm/linux/kernel/git/khilman/linux-amlogic.git";
    rev = "bf2db0b9f5808fa5b78141b68d55ec630bf06313";
    sha256 = "197psr66b3hxh794624lmd1jr16ckk0sin3hg40x79dnkmgwkba9";
  };
  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
