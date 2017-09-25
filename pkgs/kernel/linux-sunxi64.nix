{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14.0-rc2";
  modDirVersion = "4.14.0-rc2";
  extraMeta.branch = "4.14-rc2";

  src = pkgs.fetchFromGitHub {
    owner = "linux-sunxi";
    repo  = "linux-sunxi";
    # latest HEAD of branch mirror/master @ 25-09-17
    rev = "e19b205be43d11bff638cad4487008c48d21c103";
    sha256 = "0qvk30wymq2rgm21hzj6kkbglinv5d3sd9navda0hsw1mdjlzgkc";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
