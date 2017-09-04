{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./base.nix
    ./g-ether.nix
    ./buildfarm.nix
    ./prometheus.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
}
