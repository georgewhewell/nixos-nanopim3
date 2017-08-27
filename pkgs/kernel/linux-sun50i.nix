{ stdenv, linux_4_12, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import ./linux-testing.nix (args // rec {

  kernelPatches = args.kernelPatches ++ [
  {
    name = "add-sun50i-defconfig";
    patch = ../../patches/add-sun50i-defconfig.patch;
  }];

} // (args.argsOverride or {}))
