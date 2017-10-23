{ config, pkgs, ... }:

rec {

  system.build.sd = rec {
    installBootloader = "";
  };

  system.build.qemu = rec {
    /*netboot-binaries = pkgs.symlinkJoin {
      name = "qemu-boot";
      paths = with config.system; [
        build.initialRamdisk
        build.kernel
      ];
    };*/

    /*loader = { pkgs, config }:
      with config.system;
        pkgs.writeScriptBin "boot.sh" ''
          ${pkgs.qemu}/bin/qemu-system-arm \
            -machine virt \
            -kernel ${build.usb.netboot-binaries}/zImage \
            -initrd ${build.usb.netboot-binaries}/initrd
      '';*/

    vmScript = { pkgs, config }:
      with config.system;
      with pkgs.lib;
      let vmName = "test";
      in pkgs.writeScriptBin "boot-vm.sh" ''
          NIX_DISK_IMAGE=$(readlink -f ''${NIX_DISK_IMAGE:-${config.virtualisation.diskImage}})

          if ! test -e "$NIX_DISK_IMAGE"; then
              ${pkgs.qemu}/bin/qemu-img create -f qcow2 "$NIX_DISK_IMAGE" \
                ${toString config.virtualisation.diskSize}M || exit 1
          fi

          # Create a directory for storing temporary data of the running VM.
          if [ -z "$TMPDIR" -o -z "$USE_TMPDIR" ]; then
              TMPDIR=$(mktemp -d nix-vm.XXXXXXXXXX --tmpdir)
          fi

          # Create a directory for exchanging data with the VM.
          mkdir -p $TMPDIR/xchg

          cd $TMPDIR
          idx=2

          # Start QEMU.
          exec ${pkgs.qemu}/bin/qemu-kvm \
              -name ${vmName} \
              -m ${toString config.virtualisation.memorySize} \
              -smp ${toString config.virtualisation.cores} \
              ${optionalString (pkgs.stdenv.system == "x86_64-linux") "-cpu kvm64"} \
              ${concatStringsSep " " config.virtualisation.qemu.networkingOptions} \
              -virtfs local,path=/nix/store,security_model=none,mount_tag=store \
              -virtfs local,path=$TMPDIR/xchg,security_model=none,mount_tag=xchg \
              -virtfs local,path=''${SHARED_DIR:-$TMPDIR/xchg},security_model=none,mount_tag=shared \
              -drive index=0,id=drive1,file=$NIX_DISK_IMAGE,if=${config.virtualisation.qemu.diskInterface},cache=writeback,werror=report \
              -kernel ${config.system.build.toplevel}/kernel \
              -initrd ${config.system.build.toplevel}/initrd \
              -append "$(cat ${config.system.build.toplevel}/kernel-params) init=${config.system.build.toplevel}/init $QEMU_KERNEL_PARAMS" \
              ${toString config.virtualisation.qemu.options} \
              $QEMU_OPTS \
              $@
        '';
  };

}
