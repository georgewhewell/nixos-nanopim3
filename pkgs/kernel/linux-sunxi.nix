{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "sun8i-dev/add-ad9834-dt-bindings.patch"
    "sun8i-dev/add-ad9834-dt-bindings.patch"
    "sun8i-dev/add-dvfs-emac-nanopi.patch"
    "sun8i-dev/add-emac-pwr-en-orangepi-plus2e.patch"
    "sun8i-dev/add-fix-dts-for-opi-zero-emac.patch"
    "sun8i-dev/add-h3-overlays.patch"
    "sun8i-dev/add-h3-simplefb.patch"
    "sun8i-dev/add-nanopi-neoair.patch"
    "sun8i-dev/add-orangepi-zeroplus.patch"
    "sun8i-dev/add-realtek-8189fs-driver.patch"
    "sun8i-dev/add-spi-aliases.patch"
    "sun8i-dev/add-spi-flash-opi-zero.patch"
    "sun8i-dev/add-thermal-otg-wireless-opi-lite.patch"
    "sun8i-dev/add-uart-rts-cts-pins.patch"
    "sun8i-dev/add-wifi-pwrseq-opi-pc-plus.patch"
    "sun8i-dev/enable-1200mhz-on-small-orangepis.patch"
    "sun8i-dev/enable-codec-opi-2.patch"
    "sun8i-dev/fix-broken-usb0-drv.patch"
    "sun8i-dev/fix-i2c2-reg-property.patch"
    "sun8i-dev/fix-missing-eth0-alias-to-avoid-random-mac.patch"
    "sun8i-dev/increasing_DMA_block_memory_allocation_to_2048.patch"
    "sun8i-dev/orangepi-zero-add-cpufreqscaling.patch"
    "sun8i-dev/scripts-dtc-import-updates.patch"
    "sun8i-dev/spidev-remove-warnings.patch"
    "sun8i-dev/spi-sun6i-allow-large-transfers.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.0";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "megous";
    repo  = "linux";

    # latest HEAD of branch mirror/master @ 27-09-17
    rev = "c173fe35989ed23e9f14379550a056969ef6140c";
    sha256 = "0ak6r9yvzmg0j3yh7fnm72f1h3k57gjrxy2cs0bvhi1h7lirxqcd";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches ++ armbianPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
