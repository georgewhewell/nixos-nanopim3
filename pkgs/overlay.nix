{ self, super }:

rec {
  python = super.python.override {
     packageOverrides = python-self: python-super: {
       cffi = super.python2Packages.cffi.overrideAttrs (oldAttrs: {
         doCheck = false; doInstallCheck = false; checkPhase = "";
       });
     };
  };
  pythonPackages = python.pkgs;

  gnome3 = super.gnome3 // {
    networkmanager_iodine = super.gnome3.networkmanager_iodine.overrideAttrs (
      old: { buildInputs = old.buildInputs ++ [ super.pkgconfig ]; });
  };

  collectd = pkgs.collectd.override {
    libvirt = null;
  };

}
