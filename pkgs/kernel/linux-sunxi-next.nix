{ stdenv, hostPlatform, pkgs, perl, buildLinux, ... } @ args:

let
  armbianPatches = map (path: {
    name = "armbian-${path}";
    patch = "${pkgs.armbian}/patch/kernel/${path}";
  }) [
    "sunxi-next/21-sun4i-gpadc-iio-add-split-sun8i.patch"
    "sunxi-next/22-sun4i-gpadc-iio-add-H3-support.patch"
    "sunxi-next/23-sun4i-gpadc-iio-add-H3-thermal-sensor-DT.patch"
    "sunxi-next/24-sun4i-gpadc-iio-add-H3-CPU-thermal-zone.patch"
    "sunxi-next/25-sun4i-gpadc-iio-workaround-for-raw-0-read.patch"
    "sunxi-next/26-sun4i-gpadc-iio-add-h5-a64-support.patch"
    "sunxi-next/27-sun4i-gpadc-iio-add-h5-DT.patch"
    "sunxi-next/29-sun4i-gpadc-iio-add-h5-thermal-zone.patch"
    "sunxi-next/30-sun4i-drm-add-GEM-allocator.patch"
    "sunxi-next/31-drm-gem-cma-export-allocator.patch"
    "sunxi-next/33-pll-gpu-allow-set-rate-parent.patch"
#   "sunxi-next/39-rename-s_twi-pinctrl-functions.patch"
    "sunxi-next/40-add-SY8106A-regulator-driver.patch"
    "sunxi-next/41-h3-h5-Add-r_i2c-controller.patch"
    "sunxi-next/42-h3-h5-Add-r_i2c-pins.patch"
#   "sunxi-next/43-H3-cpux-allow-set-parent.patch"
#   "sunxi-next/44-H3-clk-cpu-use-pll-notifier.patch"
    "sunxi-next/45-add-h3-cpu-OPP-table.patch"
    "sunxi-next/46-H3-add-opp-table-to-cpu.patch"
    "sunxi-next/47-01-enable-dvfs-opi-zero.patch"
    "sunxi-next/47-02-enable-dvfs-opi-one.patch"
    "sunxi-next/47-03-enable-dvfs-opi-pc.patch"
    "sunxi-next/47-04-enable-dvfs-opi-2.patch"
    "sunxi-next/47-05-enable-dvfs-opi-lite.patch"
#   "sunxi-next/48-cpufreq-dt-auto-create-platdev.patch"
    "sunxi-next/49-add-h5-cpu-OPP-table.patch"
    "sunxi-next/50-H5-add-opp-table-to-cpu.patch"
    "sunxi-next/51-01-enable-dvfs-opi-pc2.patch"
    "sunxi-next/add-A64-nmi_intc.patch"
    "sunxi-next/add-H27UBG8T2BTR-nand.patch"
    "sunxi-next/add-axp803-DT.patch"
    "sunxi-next/add-missing-spi-a64.patch"
    "sunxi-next/add-opi-pc-plus-wifi-pwrseq.patch"
#   "sunxi-next/add-orangepi-zeroplus.patch"
    "sunxi-next/add-realtek-8189fs-driver.patch"
    "sunxi-next/add-sdio-wifi-orangepi-zero-plus2.patch"
    "sunxi-next/add-wifi-orangepiprime.patch"
    /*
    todo:
    /tmp/nix-build-linux-4.14-rc3.drv-0/linux-4.14-rc3/drivers/net/wireless/xradio/sdio.c: In function 'xradio_probe_of':
    /tmp/nix-build-linux-4.14-rc3.drv-0/linux-4.14-rc3/drivers/net/wireless/xradio/sdio.c:145:2: error: implicit declaration of function 'devm_request_irq' [-Werror=implicit-function-declaration]
    devm_request_irq(dev, irq, sdio_irq_handler, 0, "xradio", func);
    ^~~~~~~~~~~~~~~~
    CC [M]  drivers/regulator/mc13xxx-regulator-core.o
    cc1: some warnings being treated as errors
    make[5]: *** [/tmp/nix-build-linux-4.14-rc3.drv-0/linux-4.14-rc3/scripts/Makefile.build:313: drivers/net/wireless/xradio/sdio.o] Error 1
    make[4]: *** [/tmp/nix-build-linux-4.14-rc3.drv-0/linux-4.14-rc3/scripts/Makefile.build:572: drivers/net/wireless/xradio] Error 2
    make[4]: *** Waiting for unfinished jobs....

    "sunxi-next/add-xradio-wireless-driver.patch"
    "sunxi-next/fix-xradio-interrupt.patch"
    */
    "sunxi-next/axp20x-sysfs-interface.patch"
    "sunxi-next/set-DMA-coherent-pool-to-2M.patch"
    "sunxi-next/spidev-remove-warnings.patch"
 ];
in import <nixpkgs/pkgs/os-specific/linux/kernel/generic.nix> (args // rec {
  version = "4.14-rc5";
  modDirVersion = "4.14.0-rc5";
  extraMeta.branch = "4.14";

  src = pkgs.fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "1y383vw79jhpr15s919xwzxif2y8zbiwa64sg2aan075xfhzijp8";
  };

  kernelPatches = pkgs.linux_4_13.kernelPatches ++ armbianPatches;

  features.iwlwifi = false;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;
} // (args.argsOverride or {}))
