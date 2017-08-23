{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13-rc6";
  modDirVersion = "4.13.0-rc6";
  extraMeta.branch = "4.13";

  src = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git/snapshot/linux-amlogic-${version}.tar.gz";
    sha256 = "0f632p9gahb12dp78b4g5mxsyan1lyzscysxalp5g5824nrrybyq";
  };
  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
