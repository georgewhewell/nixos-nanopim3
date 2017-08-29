{ config, lib, pkgs, ... }:

{
  networking.wireless.enable = lib.mkDefault true;
}
