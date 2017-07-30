{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/headless.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./hardware-config.nix
    ./users.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;
  services.avahi.enable = true;
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    tmux
    htop
    stress
    vim
    ethtool
    bluez
  ];

}
