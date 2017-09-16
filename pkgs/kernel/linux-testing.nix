{ stdenv, linux_4_13, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.13.1";
  extraMeta.branch = "4.13";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1kp1lsf4314af7crpqkd2x1zx407a97r7rz3zhhskbilvsifgkny";
  };

  kernelPatches = linux_4_13.kernelPatches ++ (if stdenv.system == "armv7l-linux" then [
    {
      name = "fix_tegra_gpu_build";
      patch = ../../patches/tegra-gpu.patch;
    }
  ] else [
    {
      name = "add-sun50i-defconfig";
      patch = ../../patches/add-sun50i-defconfig.patch;
    }
  ]);

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

} // (args.argsOverride or {}))
