{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.12";
  modDirVersion = "4.12.0";
  extraMeta.branch = "4.12";

  src = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git/snapshot/linux-amlogic-4.12.tar.gz";
    sha256 = "053dr9iy4xyhaflcyaq4ljvb2qz2vwcnhhcd11m00diap2v2ycfd";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = false;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
