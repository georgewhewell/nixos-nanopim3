{ config, lib, pkgs, ... }:

{
  users.extraUsers.nixos = {
    extraGroups = ["wheel" "libvirtd" "docker" "transmission" "audio" "dialout" "plugdev" "wireshark"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      /* Put keys here */
    ];
  };

   security.sudo.wheelNeedsPassword = false;
}
