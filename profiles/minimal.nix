{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./base.nix
    ./g-ether.nix
    ./buildfarm.nix
    ../users.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;

}
