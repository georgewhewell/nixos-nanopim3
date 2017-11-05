{ config, lib, pkgs, callPackage, recurseIntoAttrs, ... }:

{
  environment.systemPackages = with pkgs; [
    tmux
    htop
    stress
    cpuburn-arm
    tinymembench
    usbutils
    lshw
    cpuminer-multi
    /*lima-memtester*/
  ];
}
