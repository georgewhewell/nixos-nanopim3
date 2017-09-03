{ config, lib, pkgs, ... }:

{
    networking.wireless.enable = true;
    networking.networkmanager.enable = lib.mkDefault false;
}
