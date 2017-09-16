{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.6-4";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "2f1317556a415cb2e5354c39532014252b37ea41";
    sha256 = "169pc4k677nrlpq46p2gcjbjng7lgl5xa7l4kfy2wk2vrmksh15l";
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
