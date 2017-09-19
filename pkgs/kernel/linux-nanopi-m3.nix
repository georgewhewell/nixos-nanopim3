{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.6-4";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "d0029aab744310d83bef99d4f0ca8e05de445ee2";
    sha256 = "0fv5c5zm04im1asxcgsw0hjsmk9744gxfiwcm4cl1q7nj3w9zg1m";
  };

  kernelPatches = [
    {
      name = "revert-cross-compile.patch";
      patch = ../../patches/revert-cross-compile.patch;
    }
    {
      name = "export-func";
      patch = ../../patches/export-func.patch;
    }
  ] ++ pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
