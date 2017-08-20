{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/headless.nix>
    ./g-ether.nix
    ./buildfarm.nix
    ../users.nix
  ];

  environment.noXlibs = true;
  sound.enable = false;
  
  services.avahi.enable = true;
  networking.networkmanager.enable = false;

}
