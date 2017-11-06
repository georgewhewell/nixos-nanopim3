{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc4";
  modDirVersion = "4.14.0-rc3";
  extraMeta.branch = "4.14";

  src = "${pkgs.x3399-sdk.src}/kernel";
  sourceRoot = "source/kernel";
  /*kernelPatches = pkgs.linux_4_13.kernelPatches;*/
  kernelPatches = with pkgs.kernelPatches; [
    bridge_stp_helper
    modinst_arg_list_too_long
  ];
  
  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
