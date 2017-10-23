{ pkgs, ... }:

{

  imports = [
    ./include/common.nix
    ./include/qemu-boot.nix
  ];

  meta = {
    platforms = [ "aarch64-linux" "armv7l-linux" ];
  };

}
