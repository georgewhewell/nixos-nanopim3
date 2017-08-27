{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./base.nix
    ./collectd.nix
    ./g-ether.nix
    ./buildfarm.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;

}
