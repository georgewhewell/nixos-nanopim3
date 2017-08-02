{ config, lib, pkgs, ... }:

{
  systemd.services.start-g-ether = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${pkgs.kmod}/bin/modprobe g_ether
      '';
  };
}
