{ config, lib, pkgs, ... }:

{
    networking.networkmanager.enable = false;
    networking.networkmanager-small.enable = lib.mkDefault true;
}
