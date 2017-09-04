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

  libffi = pkgs.libffi.overrideDerivation (
    old: rec {
      src = pkgs.fetchFromGitHub {
        owner = "libffi";
        repo = "libffi";
        rev = "b23091069adce469dc38fbcc9fd8ac9085d3c9d7"; # master @ 4/09/17
        sha256 = "0h9rpdh3vw2idw1i487jr5qh10i3s7gpsbn8izb0whknnrz4v98q";
      };
      nativeBuildInputs = [ pkgs.autoreconfHook pkgs.texinfo ];
      postFixup = ''
        mkdir -p "$dev/"
        substituteInPlace "$dev/lib/pkgconfig/libffi.pc" \
          --replace 'includedir=''${libdir}/libffi-3.2.1' "includedir=$dev"
      '';
    }
  );

  llvm = pkgs.llvm.overrideAttrs (
    old: { doCheck = false; });

}
