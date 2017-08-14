{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/headless.nix>
    ./profiles/g-ether.nix
    ./profiles/buildfarm.nix
    ./users.nix
  ];

  environment.noXlibs = true;

  services.avahi.enable = true;
  networking.networkmanager.enable = true;

}
