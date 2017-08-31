{ config, lib, pkgs, ... }:

{
    networking.networkmanager.enable = lib.mkDefault true;
}
