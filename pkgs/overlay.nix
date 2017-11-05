{ self, super }:

rec {
  python = super.python.override {
     packageOverrides = python-self: python-super: {
       cffi = super.python2Packages.cffi.overrideAttrs (oldAttrs: {
         doCheck = false; doInstallCheck = false;
       });
     };
  };

  python2Packages = python.pkgs;

  DBDSQLite = with super; with perlPackages;
    import ./DBD-SQLite.nix {
      inherit stdenv fetchurl buildPerlPackage DBI;
      inherit (pkgs) sqlite;
  };

  perlPackages = super.perlPackages // {
    inherit DBDSQLite;
  };

  gnome3 = super.gnome3 // {
    networkmanager_iodine = super.gnome3.networkmanager_iodine.overrideAttrs (
      old: { buildInputs = old.buildInputs ++ [ super.pkgconfig ]; });
  };

  jemalloc = if super.stdenv.system == "armv7l-linux" then super.jemalloc.overrideAttrs (
    old: { configureFlags = "--disable-thp"; }
  ) else super.jemalloc;

  collectd = super.collectd.override {
    libvirt = null;
    protobufc = null;
    rabbitmq-c = null;
    libgcrypt = null;
    jdk = null;
    riemann = null;
  };

}
