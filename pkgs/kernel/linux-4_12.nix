{ stdenv, pkgs, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  modDirVersion = "4.12.12";
  version = "4.12.12";
  extraMeta.branch = "4.12";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1d254yxn46ydp0x3s5cpyg4p74zvdwiqfiaaim1m3g6rwjmlkjpa";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

} // (args.argsOverride or {}))
