{ config, lib, pkgs, ... }:

{
  nix.buildCores = lib.mkDefault 0;
  nix.useSandbox = lib.mkDefault true;
  nix.extraOptions = "auto-optimise-store = true";

  nix.gc = {
    automatic = true;
    dates = "hourly";
    options = ''--max-freed "$((10 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoqpsUUtxaO0QzI9MxCs5tRjsbORDwpjFjuUFdGHJwZqm7A2MzrRV7EKfqfolgxnyaAFs7IM9AZ7o9Lus2MWX89c4OAW0upeoj2qsXMiFZH7z50Cdmg/YMw5DtVMZwPBTl0S1COWfhw959QntlTjhcYh3usIq9b3XeTELGtJSk5RmTjPIA2LJ4cemx3Ru11SySvk0LsI3uCv0Vhy9n17g1sg5eekRs5Nvg1AJtOQcH4Du/0rUwwEDd9Zjn0YiF/uPVMVh22JzWVE5dbe81g8dw+mR6GRnN3vlYbU+JgGvMKgs2DeGvPHSJWl9rwKUVO6wuruzZH+1q2HxAr58ndz81 root@nixhost"
  ];

  swapDevices = [ {
    device = "/swapfile";
    size = 2048;
  } ];

  filesystems."/".options = [
    "noatime" "commit=1800"
  ];

  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=1G" ];
  };

  powerManagement.cpuFreqGovernor = "ondemand";

  nix.binaryCaches = [
      https://hydra.satanic.link/
      https://cache.nixos.org/
  ];
  nix.binaryCachePublicKeys = [
    "hydra.satanic.link-1:U4ZvldOwA3GWLmFTqdXwUu9oS0Qzh4+H/HSl8O6ew5o="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
}
