{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13-rc3";
  modDirVersion = "4.13.0-rc3";
  extraMeta.branch = "4.13";

  src = pkgs.fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git/snapshot/linux-amlogic-4.13-rc3.tar.gz";
    sha256 = "1895z4cz18n289c0h2x4a0p7kn91kynrbpvgj28yh2aiw8xjsma6";
  };
  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
