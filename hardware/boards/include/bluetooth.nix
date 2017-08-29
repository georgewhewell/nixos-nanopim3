{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = lib.mkDefault true;
}
