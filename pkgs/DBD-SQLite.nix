{ stdenv, fetchurl, buildPerlPackage, DBI, sqlite }:

buildPerlPackage rec {
  name = "DBD-SQLite-1.50";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/${name}.tar.gz";
    sha256 = "1qcw2nzla03ywrl6mx1qklvbc8n5bn4gxqbjnvadfkwlffmi7i9s";
  };

  propagatedBuildInputs = [ DBI ];

  makeMakerFlags = "SQLITE_LOCATION=${sqlite.dev}";

  patches = [
    # Support building against our own sqlite.
    ./external-sqlite.patch
  ];

  sqlite_dev = sqlite.dev;
  sqlite_out = sqlite.out;
  postPatch = "substituteAllInPlace Makefile.PL; cat Makefile.PL";
  doCheck = false;
  preBuild =
    ''
      substituteInPlace Makefile --replace -L/usr/lib ""
    '';

  postInstall =
    ''
      # Prevent warnings from `strip'.
      chmod -R u+w $out

      # Get rid of a pointless copy of the SQLite sources.
      rm -rf $out/lib/perl5/site_perl/*/*/auto/share
    '';

  # Disabled because the tests can randomly fail due to timeouts
  # (e.g. "database is locked(5) at dbdimp.c line 402 at t/07busy.t").
  #doCheck = false;

  meta.platforms = stdenv.lib.platforms.unix;
}
