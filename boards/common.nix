{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules = [ "lz4" "lz4_compress" ];

  environment.variables.GC_INITIAL_HEAP_SIZE = "100000";
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in
    {
      # multiarch
      qca-qt5 = super.qca-qtt.overrideAttrs (
        old: { NIX_CFLAGS_COMPILE = "-Wno-narrowing"; });
      ap6212-firmware =
        pkgs.callPackage ../pkgs/ap6212-firmware.nix { };

      inherit (pkgs.callPackages ../pkgs/boot/default.nix { })
        bl1-nanopi-m3
        bl1-odroid-c2
        bsp-h5-lichee
        nanopi-load
        meson-tools
        sunxi-tools
        fip_create
        uboot-nanopi-m3;
      inherit (pkgs.callPackages ../pkgs/kernel/default.nix { });
    } // (if pkgs.stdenv.system == "aarch64-linux" then {

      openssl_1_1_0 = super.openssl_1_1_0.overrideAttrs (
        old: { configureFlags = old.configureFlags ++ ["no-afalgeng"]; });

    } else {
      xorg = super.xorg // {
        xf86videovmware = self.lib.overrideDerivation super.xorg.xf86videovmware (drv: {
          hardeningDisable = [ "all" ];
          src = pkgs.fetchurl {
            url = "https://www.x.org/archive//individual/driver/xf86-video-vmware-13.2.1.tar.gz";
            sha256 = "1hdb2vka7p6f6jv4kkq38a37i801nba3x0jqrnn52dklw9k8d43i";
          };
        });
      };

      sudo = super.sudo.overrideAttrs (
        old: { prePatch = "substituteInPlace src/Makefile.in --replace 04755 0755"; });
      spidermonkey17 = super.super.spidermonkey17.overrideAttrs (
        old: { postPatch = "rm jit-test/tests/basic/bug698584.js"; });

    });
}
