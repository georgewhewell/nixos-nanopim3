{ config, lib, pkgs, ... }:

{

  systemd.services.switch-otg-role = {
    wantedBy = [ "start-g-ether.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      echo 2 > /sys/bus/platform/devices/sunxi_usb_udc/otg_role
    '';
  };

}
