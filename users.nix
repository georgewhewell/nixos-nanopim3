{ config, lib, pkgs, ... }:

{
  users.extraUsers.nixos = {
    extraGroups = ["wheel" "libvirtd" "docker" "transmission" "audio" "dialout" "plugdev" "wireshark"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      /* Put kets here */
    ];
  };

   security.sudo.wheelNeedsPassword = false;
}
