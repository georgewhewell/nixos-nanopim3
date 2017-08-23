{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    <nixpkgs/nixos/modules/profiles/headless.nix>
    ./base.nix
    ./g-ether.nix
    ./buildfarm.nix
  #  ./prometheus.nix
    ../users.nix
  ];

  services.openssh.enable = true;

}
