{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.12";
  modDirVersion = "4.12.0";
  extraMeta.branch = "4.12";

  src = pkgs.fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "linux-sunxi";
    rev = "sunxi-next";
    sha256 = "0891v6j2hpd1kq7vkd63ysmiwhmd6f1jjprzvq9p7952bik6njcd";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
