{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14.0-rc2";
  modDirVersion = "4.14.0-rc2";
  extraMeta.branch = "4.14-rc2";

  src = pkgs.fetchFromGitHub {
    owner = "linux-sunxi";
    repo  = "linux-sunxi";

    # latest HEAD of branch mirror/master @ 27-09-17
    rev = "dc972a67cc54585bd83ad811c4e9b6ab3dcd427e";
    sha256 = "05q55hb86j802ch3nbq8z1mggnbrpvxd8rpkqzmpm7qhyy2wyxpw";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
