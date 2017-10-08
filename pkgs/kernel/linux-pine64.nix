{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "3.10.105";
  modDirVersion = "3.10.105";
  extraMeta.branch = "3.10.105";

  src = pkgs.fetchFromGitHub {
    owner = "longsleep";
    repo = "linux-pine64";
    rev = "a08f5219d240ae0edf93d090ff1fda0a82a6cb3a";
    sha256 = "11syppd9kg59g703ksr2m135bgn740k4syc6nznka0qsxw43gv60";
  };

  kernelPatches = [
    pkgs.kernelPatches.modinst_arg_list_too_long
  ];

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
