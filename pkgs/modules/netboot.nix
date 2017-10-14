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
        device = "hydra.4a:/store";
        options = [ "ro" ];
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
      };

    boot.initrd.availableKernelModules = [ "musb" "squashfs" ];
    boot.initrd.kernelModules = [ "musb-hdrc" "g_multi" "g_serial" "g_ether" ];

    # Closures to be copied to the Nix store, namely the init
    # script and the top-level system configuration directory.
    netboot.storeContents =
      [ config.system.build.toplevel ];

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = import <nixpkgs/nixos/lib/make-squashfs.nix> {
      inherit (pkgs) stdenv squashfsTools perl pathsFromGraph;
      storeContents = config.netboot.storeContents;
    };

    system.build.bootenv = pkgs.writeTextDir "bootenv.txt" ''
      #=uEnv
      bootargs=init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}
      bootcmd=bootz 0x42000000 0x43300000: 0x43000000
    '';

    system.build.netboot-binaries = pkgs.symlinkJoin {
      name = "netboot";
      paths = with config.system; [
        build.initialRamdisk
        build.kernel
        build.bootloader
        build.bootenv
      ];

      postBuild = ''
        if [ -f Image ]; then
        	KERNEL_IMAGE=Image
        else
        	KERNEL_IMAGE=zImage
        fi
        ${pkgs.ubootTools}/bin/mkimage -A arm -O linux -T kernel -C none -d $out/$KERNEL_IMAGE $out/uImage
        mkdir -p $out/nix-support
        echo "file u-boot-sunxi-with-spl.bin $out/u-boot-sunxi-with-spl.bin" >> $out/nix-support/hydra-build-products
        echo "file uImage $out/uImage" >> $out/nix-support/hydra-build-products
        echo "file initrd $out/initrd" >> $out/nix-support/hydra-build-products
        echo "file bootenv.txt $out/bootenv.txt" >> $out/nix-support/hydra-build-products
      '';
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
