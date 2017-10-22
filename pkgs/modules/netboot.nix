# This module creates netboot media containing the given NixOS
# configuration.

{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    netboot.storeContents = mkOption {
      example = literalExample "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated netboot image.
      '';
    };

  };

  config = rec {

    boot.loader.grub.version = 2;

    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = false;

    # !!! Hack - attributes expected by other modules.
    boot.initrd.network.enable = true;

    environment.systemPackages = [ ];

    fileSystems."/" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" =
      { fsType = "nfs";
        device = "192.168.23.213:/export/store";
        options = [ "ro" "nolock" ];
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

    fileSystems."/nix/store" =
      { fsType = "unionfs-fuse";
        device = "unionfs";
        options = [ "allow_other" "cow" "nonempty" "chroot=/mnt-root" "max_files=32768" "hide_meta_files" "dirs=/nix/.rw-store=rw:/nix/.ro-store=ro" ];
        neededForBoot = true;
      };

    boot.initrd.kernelModules = [ "libcomposite" ];

    boot.specialFileSystems."/sys/kernel/config" = {
      fsType = "configfs";
      device = "none";
    };

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
    in (''
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
        udhcpc --quit --now -i usb0 --script ${udhcpcScript} && hasNetwork=1
      fi

      if [ -n "$hasNetwork" ]; then
        echo "networking is up!"
      fi
    '');

    systemd.services."getty@ttyGS0" = {
      enable = true;
      after = [ "start-g-ether.service" ];
      wantedBy = [ "basic.target" ];
    };

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
