{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.y";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "longsleep";
    repo = "linux";
    rev = "a08f5219d240ae0edf93d090ff1fda0a82a6cb3a";
    sha256 = "11syppd9kg59g703ksr2m135bgn740k4syc6nznka0qsxw43gv60";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
