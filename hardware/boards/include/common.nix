{ config, lib, pkgs, ... }:

{
  imports = [
    ./sd-image.nix
  ];

  nixpkgs.config.packageOverrides =
    import ../../../pkgs/top-level.nix;
}
