{ config, lib, pkgs, ... }:

{

  boot.initrd.availableKernelModules = [ "dwc2" "g_multi" "g_ether" "g_serial" ];
  systemd.services.start-g-ether = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.kmod}/bin/modprobe g_multi
        ${pkgs.kmod}/bin/modprobe g_serial
        ${pkgs.kmod}/bin/modprobe g_ether
      '';
    };
  };

}
