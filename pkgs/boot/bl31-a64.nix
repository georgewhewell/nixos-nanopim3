{ config, lib, pkgs }:

pkgs.stdenv.mkDerivation rec {
    version="master";
    name = "bl31-a64-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "apritzel";
      repo = "arm-trusted-firmware";
      rev = "87e8aedd80e6448a55b2328768d956fcb5f5d410";
      sha256 = "1hnr1123ik840ihvnck8agqm9r79x8hbaq4d4bvn1q9ayd2d5sy0";
    };

    patches = [
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/01-add-SMC-mailbox.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/02-add-handler-boilerplate.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/03-add-clock-handling.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/04-implement-CPU-clock.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/05-allow-setting-CPU-voltage.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/06-refactor-poweroff.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/07-refactor-power-code.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/08-add-DVFS.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/09-add-THS-sensor.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/10-add-device-power-state.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/add-SRAM-mapping-for-SCPI.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/enable-a53-errata-workaround.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw1/set-rsb-to-nonsec.patch"
      "${pkgs.armbian}/patch/atf/atf-sun50iw2/add-pc2-shutdown.patch"
    ];

    dontStrip = true;
    hardeningDisable = [ "all" ];
    nativeBuildInputs = [ pkgs.gcc6 ];

    buildPhase = ''
      make PLAT=sun50iw1p1 DEBUG=1 bl31
    '';

    installPhase = ''
      cp build/sun50iw1p1/debug/bl31.bin $out
    '';
}
