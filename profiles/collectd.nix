{ config, lib, pkgs, ... }:

{
    networking.firewall.allowedTCPPorts = [ 9100 ];
    services.collectd = {
      enable = true;
      extraConfig = ''
        # Output/write plugin (need at least one, if metrics are to be persisted)
        <Plugin "write_prometheus">
          Port "9100"
        </Plugin>
      '';
    };
}
