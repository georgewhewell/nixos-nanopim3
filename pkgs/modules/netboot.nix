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

    networking.interfaces."usb0" = {
      ipAddress = "10.10.10.2";
      prefixLength = 24;
    };

    fileSystems."/" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" =
      { fsType = "nfs";
        device = "10.10.10.1:/export/store";
        options = [ "ro" "nolock" ];
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" =
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

    fileSystems."/blarg" =
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

    fileSystems."/zzzzzzzzzorg" =
      { fsType = "tmpfs";
        options = [ "nofail" ];
        neededForBoot = true;
      };

    boot.initrd.availableKernelModules = [ "usb_f_rndis" "usb_f_acm" "u_ether" "u_serial" "sunxi" "wire" "squashfs" "musb_hdrc" ];
    boot.initrd.kernelModules = [ "loop" "libcomposite" ];

    boot.kernelParams = [ "ignore_loglevel" "boot.shell_on_fail" "console=ttyS0,115200" "cma=96M" ];

    boot.specialFileSystems."/sys/kernel/config" = {
      fsType = "configfs";
      device = "none";
    };

    boot.initrd.postDeviceCommands = ''
      # from http://irq5.io/2016/12/22/raspberry-pi-zero-as-multiple-usb-gadgets/
      set -e
      INITIAL_DIR=$(pwd)

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

      udevadm settle

      ls /sys/class/udc/ > UDC

      # todo: nix this
      ${pkgs.iproute}/bin/ip link set dev usb0 up
      ${pkgs.iproute}/bin/ip addr add 10.10.10.2/24 dev usb0
      ${pkgs.iproute}/bin/ip route add default via 10.10.10.1

      echo "Set up USB eth"
      cd $INITIAL_DIR
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
