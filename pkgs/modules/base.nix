{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.nix-arm;
  hardware = import ../../hardware/boards { };

in {
  options.nix-arm = {

    platform = mkOption {
      type = types.str;
      example = odroid-c2;
    };

  };

  config = hardware.boards."${cfg.platform}";

}
