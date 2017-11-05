{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
  ];

  installer.cloneConfigIncludes = [
    "nixos-nanopim3/hardware/boards/${config.networking.hostName}.nix"
    "nixos-nanopim3/profiles/base.nix"
  ];

  environment.variables.GC_INITIAL_HEAP_SIZE = "100000";
  boot.kernel.sysctl."vm.overcommit_memory" = "1";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  powerManagement.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "performance";

  # dont need :)
  services.nixosManual.enable = lib.mkDefault false;
  programs.man.enable = lib.mkDefault false;
  programs.info.enable = lib.mkDefault false;

  services.openssh.enable = lib.mkDefault true;
  # Allow the user to log in as root without a password.
  users.extraUsers.root.initialHashedPassword = "";

}
