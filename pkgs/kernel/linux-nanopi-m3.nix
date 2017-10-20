{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "s5p6818-dev/01-patch-4.11.6-7.patch.patch"
    "s5p6818-dev/01-patch-4.11.7-8.patch.patch"
    "s5p6818-dev/01-patch-4.11.8-9.patch.patch"
    "s5p6818-dev/01-patch-4.11.9-10.patch.patch"
    "s5p6818-dev/02-patch-4.11.10-11.patch"
    "s5p6818-dev/02-patch-4.11.11-12.patch"
    "s5p6818-dev/arm64_increasing_DMA_block_memory_allocation_to_2048.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.11.11-12";
  modDirVersion = "4.11.6";
  extraMeta.branch = "4.11";

  src = pkgs.fetchFromGitHub {
    owner = "rafaello7";
    repo = "linux-nanopi-m3";
    rev = "v4.11.6-8";
    sha256 = "0q6yrf5c3ysxyyzwpsjf3gb1s11dcif9ggc911y0xiizd97n4mb0";
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
