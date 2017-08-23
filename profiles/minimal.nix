{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/headless.nix>
    ./g-ether.nix
    ./buildfarm.nix
    ./prometheus.nix
    ../users.nix
  ];

  environment.noXlibs = true;
  sound.enable = false;

  networking.networkmanager.enable = true;

}
