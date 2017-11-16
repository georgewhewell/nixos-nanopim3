{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

with pkgs;

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "sunxi64-dev/a64-DT-DVFS.patch"
    "sunxi64-dev/a64-DVFS-cpu-supply.patch"
    "sunxi64-dev/a64-pll_cpux-test.patch"
    "sunxi64-dev/add-overlay-compilation-support.patch"
    "sunxi64-dev/add-spi-flash-pc2.patch"
    "sunxi64-dev/add-sun50i-ths.patch"
    "sunxi64-dev/add-sunxi64-overlays.patch"
    "sunxi64-dev/add-sy8106a-driver.patch"
    "sunxi64-dev/arm64_increasing_DMA_block_memory_allocation_to_2048.patch"
    "sunxi64-dev/enable-fsl-timer-errata.patch"
    "sunxi64-dev/fix-i2c2-reg-property.patch"
    "sunxi64-dev/scripts-dtc-import-updates.patch"
    "sunxi64-dev/spidev-remove-warnings.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc6";
  modDirVersion = "4.14.0-rc6";
  extraMeta.branch = "4.14";

  src = fetchFromGitHub {
    owner = "Icenowy";
    repo = "linux";
    rev = "8b92245f06bfe048e99902336208ee5a15f63c2e";
    sha256 = "0y0d54sl1rvvzb5fcdl67p1ccpcp64rkr5vgzq1ryhazn1z7iadm";
  };

  kernelPatches = linux_4_13.kernelPatches ++ armbianPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
