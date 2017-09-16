{ self, super }:

rec {
  python = super.python.override {
     packageOverrides = python-self: python-super: {
       cffi = super.pythonPackages.cffi.overrideAttrs (oldAttrs: {
         doCheck = false; doInstallCheck = false; checkPhase = "";
       });
     };
  };
  pythonPackages = python.pkgs;

  gnome3 = super.gnome3 // {
    networkmanager_iodine = super.gnome3.networkmanager_iodine.overrideAttrs (
      old: { buildInputs = old.buildInputs ++ [ super.pkgconfig ]; });
  };

  collectd = super.collectd.override {
    libvirt = null;
    protobufc = null;
    rabbitmq-c = null;
    libgcrypt = null;
    jdk = null;
  };

}
