{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./base.nix
    ./dev-utils.nix
    ./g-ether.nix
    ./buildfarm.nix
    /*./prometheus.nix*/
    ../users.nix
  ];

  services.avahi.enable = lib.mkDefault true;

  services.xserver = {
    enable = true;

    # Automatically login as root.
    displayManager.slim = {
      enable = true;
      defaultUser = "root";
      autoLogin = true;
    };

    desktopManager.plasma5 = {
      enable = true;
      enableQt4Support = false;
    };
  };

}
