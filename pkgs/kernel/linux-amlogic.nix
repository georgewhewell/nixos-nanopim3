{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git/snapshot/linux-amlogic-${version}.tar.gz";
    sha256 = "1x8fww17ga2rm1q56plzsknkccmj3ily1bqp2q3rx984kk4bc5k7";
  };
  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
