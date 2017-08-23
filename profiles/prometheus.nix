{ config, lib, pkgs, ... }:

{
  systemd.services.prometheus-node-exporter = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      TimeoutStartSec = 0;
      Restart = "always";
      ExecStart = ''${pkgs.prometheus-node-exporter}/bin/node_exporter'';
    };
  };

  networking.firewall.allowedTCPPorts = [ 9100 ];
}
