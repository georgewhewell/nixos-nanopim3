{ pkgs, ... }:

{
  /*xorg = pkgs.xorg // {
    xf86videovmware = pkgs.lib.overrideDerivation pkgs.xorg.xf86videovmware (drv: {
      hardeningDisable = [ "all" ];
      src = pkgs.fetchurl {
        url = "https://www.x.org/archive//individual/driver/xf86-video-vmware-13.2.1.tar.gz";
        sha256 = "1hdb2vka7p6f6jv4kkq38a37i801nba3x0jqrnn52dklw9k8d43i";
      };
    });
  };*/
  libffi = pkgs.libffi.overrideAttrs (
    old: {
      src = pkgs.fetchFromGitHub {
        owner = "libffi";
        repo = "libffi";
        rev = "b23091069adce469dc38fbcc9fd8ac9085d3c9d7"; # master @ 4/09/17
        sha256 = "1bvshfa9pa012yzdwapi3nalpgcwmfq7d3n3w3mlr357a6kq64qk";
      };
    }
  );

  llvm = pkgs.llvm.overrideAttrs (
    old: { doCheck = false; });

  qca-qt5 = pkgs.qca-qtt.overrideAttrs (
    old: { hardeningDisable = [ "all" ]; });
}
