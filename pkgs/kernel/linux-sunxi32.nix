{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13";
  modDirVersion = "4.13.0-rc7";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "megous";
    repo = "linux";
    rev = "601a3e793535243a3b07f5fe5c8423f8643c480f";
    sha256 = "1dg4x6vimn556mh1k2wdpqri43dpdxpaps1jih889v4bp5h5zfwb";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
