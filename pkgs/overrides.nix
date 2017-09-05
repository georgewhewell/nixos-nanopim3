{ pkgs }:

{

  networkmanager_iodine = pkgs.networkmanager_iodine.overrideAttrs (
    old: { buildInputs = old.buildInputs ++ [ pkgs.pkgconfig ]; });

  llvm = pkgs.llvm.overrideAttrs (
    old: { doCheck = false; });

}
