{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11";
  modDirVersion = "4.11.10";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "Icenowy";
    repo = "linux";
    rev = "0ed8d168d5426195268f1169169ae9aada1f92a6";
    sha256 = "0nvzslw87qq9d95lpbgsrg0md5pv5pjhapksf1grz7ycc0f8p71c";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches ++ [
    {
      name = "add-sun50i-defconfig";
      patch = ../../patches/add-sun50i-defconfig.patch;
    }
  ];

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
