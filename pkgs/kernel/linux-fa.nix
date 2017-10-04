{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.2";
  modDirVersion = "4.11.2";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "friendlyarm";
    repo  = "linux";
    # latest HEAD of branch sunxi-4.11.y @ 27-09-17
    rev = "5fd7aa916e6c93df69f184b03e37cca0284f9550";
    sha256 = "004y974778k51p4s96dpv5qwiq510g7i15lh92hr9ygg9r2rawz5";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
