{ config, lib, pkgs, ... }:

{
    /*networking.wireless.enable = true;*/
    networking.networkmanager.enable = false;
    networking.networkmanager-small.enable = lib.mkDefault true;
}
