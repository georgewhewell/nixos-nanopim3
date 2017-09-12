{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.6-4";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "951d07d7592855be7ba8d31bbf6889c1e4c0efaf";
    sha256 = "19460hqc959ggfnrfgbivdsbba3kj9nr7qb72g486sc53k8x15wg";
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
