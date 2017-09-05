{ pkgs }:

{
  pythonPackages = pkgs.pythonPackages // {
    cffi = pkgs.python27Packages.cffi.overrideAttrs (oldAttrs: {
      doCheck = false; doInstallCheck = false; }); };

  networkmanager_iodine = pkgs.networkmanager_iodine.overrideAttrs (
    old: { buildInputs = old.buildInputs ++ [ pkgs.pkgconfig ]; });

  llvm_4 = pkgs.llvm_4.overrideAttrs (
    old: { doCheck = false; });

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

}
