{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
   armbianPatches = map (path: {
     name = "armbian-${path}";
     patch = "${pkgs.armbian}/patch/kernel/${path}";
   }) [
     "sun8i-dev/add-BergMicro-SPI-flashes.patch"
     "sun8i-dev/add-configfs-overlay-for-v4.11.x.patch"
     "sun8i-dev/add-fix-dts-for-opi-zero-emac.patch"
     "sun8i-dev/add-h3-simplefb.patch"
     "sun8i-dev/add-orangepi-zeroplus.patch"
     "sun8i-dev/add-realtek-8189fs-driver.patch"
     "sun8i-dev/add-spi-aliases.patch"
     "sun8i-dev/add-spi-flash-opi-zero.patch"
     "sun8i-dev/Add_support_for_Xbox_One_Digital_TV_Tuner.patch"
     "sun8i-dev/add-uart-rts-cts-pins.patch"
     "sun8i-dev/enable-codec-opi-2.patch"
     "sun8i-dev/fix-i2c2-reg-property.patch"
     "sun8i-dev/fix-missing-eth0-alias-to-avoid-random-mac.patch"
     "sun8i-dev/increasing_DMA_block_memory_allocation_to_2048.patch"
     "sun8i-dev/spidev-remove-warnings.patch"
 ];
 in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13";
  modDirVersion = "4.13.0";
  extraMeta.branch = "4.13";

  src = pkgs.fetchFromGitHub {
    owner = "megous";
    repo = "linux";
    rev = "c173fe35989ed23e9f14379550a056969ef6140c";
    sha256 = "0ak6r9yvzmg0j3yh7fnm72f1h3k57gjrxy2cs0bvhi1h7lirxqcd";
  };

  kernelPatches = pkgs.linux_4_12.kernelPatches ++ armbianPatches;
  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
