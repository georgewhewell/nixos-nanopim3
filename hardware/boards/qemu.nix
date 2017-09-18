{ config, lib, pkgs, ... }:

with lib;
let
  platforms = (import ../platforms.nix);
in
{

  imports = [
    ./include/common.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/otg-role.nix
    ./include/sd-image.nix
  ];

  nixpkgs.config.writeBootloader = "echo fake bootloader!";

}
