{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <board/hardware-config.nix>
    ../users.nix
  ];

  networking.networkmanager.enable = lib.mkDefault true;

  services.nixosManual.enable = lib.mkDefault false;
  programs.man.enable = lib.mkDefault false;
  programs.info.enable = lib.mkDefault false;

  services.avahi.enable = true;

  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome3 = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.gnome3.nautilus ];
    };
  };

}
