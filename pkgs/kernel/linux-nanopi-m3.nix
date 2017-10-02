{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.6-6";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "v${version}";
    sha256 = "15jdsnx7n9rk77ddmsg6dik3my3lj7y4ncm2x9w83705y31sfggz";
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
  ] ++ pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
