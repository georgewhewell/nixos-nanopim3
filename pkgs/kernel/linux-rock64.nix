{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.y";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "ayufan-rock64";
    repo = "linux-mainline-kernel";
    rev = "d3263fdb098d8d947ff81f74174d3b929b4ce227";
    sha256 = "0309kvm1k3297cnam6vvagssgjalgkni8cvgc8ak7jjd3jjpbglj";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;
  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
