{ config, lib, pkgs, ... }:

{

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  services.openssh.enable = true;

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    git
    tmux
    htop
    stress
    vim
    ethtool
    bluez
    cifs-utils
    nfs-utils
  ];

  environment.variables.GC_INITIAL_HEAP_SIZE = "100000";
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
    super.imagemagick = super.imagemagick.overrideAttrs (
      old: { arch = "aarch64"; });
    super.gcc = super.gcc6;

    openssl_1_1_0 = super.openssl_1_1_0.overrideAttrs (
      old: { configureFlags = old.configureFlags ++ ["no-afalgeng"]; });

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

    inherit (pkgs.callPackages ../pkgs/kernel/default.nix { })
      linuxPackages_testing_local
      linuxPackages_amlogic
      linuxPackages_nanopi-m3;
  };
}
