{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.6-nanopim3";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "b8528f62a3432670f224f6f3cd39a68f77b16b5b";
    sha256 = "0891v6j2hpd1kq7vkd63ysmiwhmd6f1jjprzvq9p7952bik6njcd";
  };

  kernelPatches = [
    {
      name = "revert-cross-compile.patch";
      patch = patches/revert-cross-compile.patch;
    }
    {
      name = "export-func";
      patch = patches/export-func.patch;
    }
  ] ++ pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
