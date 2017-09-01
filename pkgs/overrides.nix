super: let
  pkgs = super.pkgs; in {
    xorg = super.xorg // {
      xf86videovmware = pkgs.lib.overrideDerivation super.xorg.xf86videovmware (drv: {
        hardeningDisable = [ "all" ];
        src = pkgs.fetchurl {
          url = "https://www.x.org/archive//individual/driver/xf86-video-vmware-13.2.1.tar.gz";
          sha256 = "1hdb2vka7p6f6jv4kkq38a37i801nba3x0jqrnn52dklw9k8d43i";
        };
      });
    };

    qca-qt5 = super.qca-qtt.overrideAttrs (
      old: { hardeningDisable = [ "all" ]; });

}
