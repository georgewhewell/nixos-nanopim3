{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "sunxi64-dev/a64-DT-DVFS.patch"
    "sunxi64-dev/a64-DVFS-cpu-supply.patch"
    "sunxi64-dev/a64-pll_cpux-test.patch"
    "sunxi64-dev/add-sun50i-ths.patch"
    "sunxi64-dev/add-sunxi64-overlays.patch"
    "sunxi64-dev/add-sy8106a-driver.patch"
    "sunxi64-dev/add-ths-DT-h5.patch"
    "sunxi64-dev/arm64_increasing_DMA_block_memory_allocation_to_2048.patch"
    "sunxi64-dev/cpufreq-dt-platdev-Automatically-create-cpufreq-device-with-OPP-v2.patch"
    "sunxi64-dev/enable-fsl-timer-errata.patch"
    "sunxi64-dev/fix-i2c2-reg-property.patch"
    "sunxi64-dev/scripts-dtc-import-updates.patch"
    "sunxi64-dev/spidev-remove-warnings.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.y";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "Icenowy";
    repo = "linux";
    rev = "sunxi64-${version}";
    sha256 = "1l69aadh71gv3rww6ypjm9rgahhv93y04jxfvvsbpliys677m36n";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches ++ armbianPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
