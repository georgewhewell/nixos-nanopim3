{ pkgs, ... }:

{

  imports = [
    ./include/common.nix
    ./include/qemu-boot.nix
    ./include/bluetooth.nix
    ./include/wireless.nix
    ./include/otg-role.nix
  ];

  meta = {
    platforms = [ "aarch64-linux" "armv7l-linux" ];
  };

}
