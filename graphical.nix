{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/profiles/graphical.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
    ./hardware-config.nix
    ./users.nix
  ];

  networking.networkmanager.enable = false;

  services.xserver = {
    videoDrivers = [ "vesa" ]; # other defaults dont compile
    desktopManager.plasma5.enableQt4Support = false; # qt4 things dont compile
  };

  nixpkgs.config = {
    # fix some packages that dont build on aarch64
    packageOverrides = super: let self = super.pkgs; in {
      openssl_1_1_0 = super.openssl_1_1_0.overrideAttrs (old: { configureFlags = old.configureFlags ++ ["no-afalgeng"]; });
      qca-qt5 = super.qca-qtt.overrideAttrs (old: { NIX_CFLAGS_COMPILE = "-Wno-narrowing"; });
    };
  };
}
