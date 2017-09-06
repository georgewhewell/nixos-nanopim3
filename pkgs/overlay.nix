{ self, super }:

let
  pythonOverrides = (selfpkgs: selfpkgs // {
    cffi = super.cffi.overrideAttrs (oldAttrs: {
      doCheck = false; doInstallCheck = false; checkPhase = "";
    });
  });
in {
  pythonPackages = pythonOverrides super.pythonPackages;
  python2Packages = pythonOverrides super.python2Packages;

  gnome3 = super.gnome3 // {
    networkmanager_iodine = super.gnome3.networkmanager_iodine.overrideAttrs (
      old: { buildInputs = old.buildInputs ++ [ super.pkgconfig ]; });
  };

}
