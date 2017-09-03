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
  llvm = pkgs.llvm.overrideAttrs (
    old: { doCheck = false; });
  qca-qt5 = pkgs.qca-qtt.overrideAttrs (
    old: { hardeningDisable = [ "all" ]; });
}
