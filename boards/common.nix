{ config, lib, pkgs, ... }:

{

  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/headless.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  sound.enable = false;
  services.openssh.enable = true;

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

  nixpkgs.config = {
    packageOverrides = pkgs: {
      inherit (pkgs.callPackages ../pkgs/boot/default.nix { })
        bl1-nanopi-m3
        nanopi-load
        meson-tools
        sunxi-tools
        uboot-hardkernel
        uboot-nanopi-m3;
      inherit (pkgs.callPackages ../pkgs/kernel/default.nix { })
        linuxPackages_sunxi
        linuxPackages_amlogic
        linuxPackages_nanopi-m3;
      ap6212-firmware = pkgs.callPackage ../pkgs/ap6212-firmware.nix { };
    };
  };
}
