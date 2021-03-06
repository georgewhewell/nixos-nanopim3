{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/minimal.nix>
    ./base.nix
    ./dev-utils.nix
  ];

  sound.enable = false;
  services.openssh.enable = true;
  environment.noXlibs = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

}
