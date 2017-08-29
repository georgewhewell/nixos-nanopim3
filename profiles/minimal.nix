{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./base.nix
    ./g-ether.nix
    ./buildfarm.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;

  networking.useNetworkd = true;

  # https://github.com/NixOS/nixpkgs/issues/18962
  systemd.network.networks."99-main".enable = false;
}
