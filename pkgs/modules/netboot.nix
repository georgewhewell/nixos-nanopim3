# This module creates netboot media containing the given NixOS
# configuration.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.netboot;
in
{
  options = {

    netboot.libcomposite.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Create libcomposite gadgets from initrd
      '';
    };

    netboot.storeContents = mkOption {
      example = literalExample "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated netboot image.
      '';
    };

  };

  config = rec {

    /*boot.loader.grub.version = 2;*/
    boot.loader.grub.enable = false;

    fileSystems."/" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # image) to make this a live CD.
    /*fileSystems."/nix/.ro-store" =
      { fsType = "squashfs";
        device = "./nix-store.squashfs";
        options = [ "loop" ];
        neededForBoot = true;
      };*/

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" =
      { fsType = "squashfs";
        device = "/dev/nbd0";
        options = [  ];
        neededForBoot = true;
      };

    fileSystems."/nix/store" =
      { fsType = "overlay";
        device = "overlay";
        options = [
          "rw" "relatime"
          "default_permissions"
          "workdir=/mnt-root/nix/.rw-store"
          "lowerdir=/mnt-root/nix/.ro-store"
          "upperdir=/mnt-root/nix/store"
        ];
        neededForBoot = true;
      };

    boot.initrd.availableKernelModules = [
      "usb_f_rndis" "usb_f_acm" "u_ether" "u_serial" ];
    boot.initrd.kernelModules = [ "loop" "squashfs" "nbd" "overlay" "libcomposite" ];

    boot.specialFileSystems."/sys/kernel/config" = {
      fsType = "configfs";
      device = "none";
    };

    networking.useNetworkd = true;

    boot.initrd.preLVMCommands = let
      udhcpcScript = pkgs.writeScript "udhcp-script"
      ''
        #! /bin/sh
        if [ "$1" = bound ]; then
          ip address add "$ip/$mask" dev "$interface"
          if [ -n "$router" ]; then
            ip route add default via "$router" dev "$interface"
          fi
          if [ -n "$dns" ]; then
            rm -f /etc/resolv.conf
            for i in $dns; do
              echo "nameserver $dns" >> /etc/resolv.conf
            done
          fi
        fi
      '';
      mountnbd = ''
        ${pkgs.nbd}/bin/nbd-client 192.168.23.213 9000 /dev/nbd0 -persist -systemd-mark -s
        ${pkgs.nbd}/bin/nbd-client 192.168.23.213 9001 /dev/nbd1 -persist -systemd-mark -s
      '';
    in mkIf cfg.libcomposite.enable (''
      # from http://irq5.io/2016/12/22/raspberry-pi-zero-as-multiple-usb-gadgets/
      INITIALDIR=$(pwd)

      echo "Setting up USB gadget"

      cd /sys/kernel/config/usb_gadget/
      mkdir g && cd g

      echo 0x1d6b > idVendor  # Linux Foundation
      echo 0x0104 > idProduct # Multifunction Composite Gadget
      echo 0x0100 > bcdDevice # v1.0.0
      echo 0x0200 > bcdUSB    # USB 2.0

      mkdir -p strings/0x409
      echo "deadbeef00115599"    > strings/0x409/serialnumber
      echo "NixOS-Embedded"      > strings/0x409/manufacturer
      echo "Net/Serial Gadget"   > strings/0x409/product

      mkdir -p functions/acm.usb0    # serial
      mkdir -p functions/rndis.usb0  # network

      mkdir -p configs/c.1
      echo 250 > configs/c.1/MaxPower
      ln -s functions/rndis.usb0 configs/c.1/
      ln -s functions/acm.usb0   configs/c.1/

      # make sure udc is created..
      udevadm settle

      ls /sys/class/udc/ > UDC

      # make sure interface exists before continue
      udevadm settle

      echo "Gadget created"

      cd $INITIALDIR

      for o in $(cat /proc/cmdline); do
        case $o in
          ip=*)
            ipconfig $o && hasNetwork=1
            ;;
        esac
      done

      if [ -z "$hasNetwork" ]; then

        # Bring up all interfaces.
        for iface in $(cd /sys/class/net && ls); do
          echo "bringing up network interface $iface..."
          ip link set "$iface" up
        done

        # Acquire a DHCP lease.
        echo "acquiring IP address via DHCP..."
        udhcpc --quit --now -i usb0 -T 5 --script ${udhcpcScript} && hasNetwork=1
        udhcpc --quit --now -i eth0 -T 5 --script ${udhcpcScript} && hasNetwork=1
      fi

      if [ -n "$hasNetwork" ]; then
        echo "networking is up!"
      fi

      ${mountnbd}
      mkdir -p /mnt-root/nix/.rw-store
    '');

    boot.initrd.network.enable = true;

    boot.initrd.postMountCommands = ''
      echo postMount
    '';
    # Closures to be copied to the Nix store, namely the init
    # script and the top-level system configuration directory.
    netboot.storeContents =
      [ config.system.build.toplevel ];

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = import <nixpkgs/nixos/lib/make-squashfs.nix> {
      inherit (pkgs) stdenv squashfsTools perl pathsFromGraph;
      storeContents = config.netboot.storeContents;
    };

    boot.loader.timeout = 10;
    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store
        # in the Nix database in the tmpfs.
        ${config.nix.package}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

  };

}
