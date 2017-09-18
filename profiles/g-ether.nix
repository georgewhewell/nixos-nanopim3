{ config, lib, pkgs, ... }:

{
  systemd.services."serial-getty@ttyGS0" = {
    enable = true;
    after = [ "start-g-ether.service" ];
  };

  systemd.services."serial-getty@ttyACM0".enable = true;

  systemd.services.start-g-ether = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    path = [ pkgs.kmod ];
    script = ''
      # from http://irq5.io/2016/12/22/raspberry-pi-zero-as-multiple-usb-gadgets/
      set -e

      ${pkgs.kmod}/bin/modprobe libcomposite

      cd /sys/kernel/config/usb_gadget/
      mkdir g && cd g

      echo 0x1d6b > idVendor  # Linux Foundation
      echo 0x0104 > idProduct # Multifunction Composite Gadget
      echo 0x0100 > bcdDevice # v1.0.0
      echo 0x0200 > bcdUSB    # USB 2.0

      mkdir -p strings/0x409
      echo "deadbeef00115599" > strings/0x409/serialnumber
      echo "NixOS-Embedded"        > strings/0x409/manufacturer
      echo "Net/Serial Gadget"   > strings/0x409/product

      mkdir -p functions/acm.usb0    # serial
      mkdir -p functions/rndis.usb0  # network

      mkdir -p configs/c.1
      echo 250 > configs/c.1/MaxPower
      ln -s functions/rndis.usb0 configs/c.1/
      ln -s functions/acm.usb0   configs/c.1/

      ${pkgs.udev}/bin/udevadm settle -t 5 || :
      ls /sys/class/udc/ > UDC

      ${pkgs.nettools}/bin/ifconfig usb0 up
    '';
  };

}
