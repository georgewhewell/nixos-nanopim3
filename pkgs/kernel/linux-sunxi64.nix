{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13-rc6";
  modDirVersion = "4.13.0-rc6";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "Icenowy";
    repo = "linux";
    rev = "sunxi64-${version}";
    sha256 = "1rzha4bp5sq0d0vkq0af25vyazs24y3gg8zbf1znwbj331b409mq";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches ++ [{
      name = "add-sun50i-defconfig";
      patch = ../../patches/add-sun50i-defconfig.patch;
  }];

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
