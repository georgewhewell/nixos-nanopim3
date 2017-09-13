{ config, lib, pkgs, ... }:

{
    networking.networkmanager.enable = false;
    networking.networkmanager-small.enable = false;
    networking.wireless.enable = true;
}
