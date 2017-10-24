{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "sunxi-next/add-axp803-DT.patch"
    "sunxi-next/axp20x-sysfs-interface.patch"
    "sunxi-next/set-DMA-coherent-pool-to-2M.patch"
    "sunxi-next/spidev-remove-warnings.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc3";
  modDirVersion = "4.14.0-rc3";
  extraMeta.branch = "4.14";

  src = pkgs.fetchFromGitHub {
    owner = "wens";
    repo = "linux";
    rev = "dad1b42553495d209de88f0091426c4d5a13291d";
    sha256 = "13p767c2x81xmaravyfbg5gasg32fzcggk1m8v9cqiafykjbnlm6";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches ++ armbianPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
