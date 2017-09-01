{ config, lib, pkgs, ... }:

{
  imports = [
    ./sd-image.nix
  ];

  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in
    (import ../../../pkgs/top-level.nix { inherit pkgs; });
}
