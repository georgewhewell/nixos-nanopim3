{ stdenv, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13-rc6";
  modDirVersion = "4.13.0-rc6";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "06jdbgihdjmq84d7km43f3w6d3hwmbnv3sgzip3nhx77l14cp7f2";
  };

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

} // (args.argsOverride or {}))
