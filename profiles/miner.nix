{ config, lib, pkgs, ... }:

{

  systemd.services.miner = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''${pkgs.cpuminer-multi}/bin/cpuminer \
        -o stratum+tcp://pool-eu.bloxstor.com:3003 -u VK4HHdmVCphVpjvUn1wty7X7yMgFp8PAEK.${config.networking.hostName}
      '';
      Nice = 19;
    };
  };

}
