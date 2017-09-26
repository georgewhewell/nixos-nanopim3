{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.9.y";
  modDirVersion = "4.9.51";
  extraMeta.branch = "4.9";

  src = pkgs.fetchFromGitHub {
    owner = "hardkernel";
    repo  = "linux";
    # latest HEAD of branch mirror/master @ 25-09-17
    rev = "2cb5bddedfc08f93cd8442d3cf9babe2a4bf9cb0";
    sha256 = "0chc1lw0k7k212wgnfdhri3ywpybm71hcsp6yjdaia32ppm3mjx9";
  };

  kernelPatches = pkgs.linux_4_9.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
