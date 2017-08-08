{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/headless.nix>
    <board/hardware-config.nix>
    ./profiles/g-ether.nix
    ./profiles/buildfarm.nix
    ./users.nix
  ];

  environment.noXlibs = true;

  services.avahi.enable = true;
  networking.networkmanager.enable = true;

  users.extraUsers.root.initialHashedPassword = "";

}
