{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    tmux
    htop
    stress
    vim
    ethtool
    cifs-utils
    nfs-utils
  ];
}
