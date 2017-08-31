{ platforms }:

{
  armv7l-hf-multiplatform = rec {
    config = "arm-unknown-linux-gnueabihf";
    bigEndian = false;
    arch = "armv7-a";
    float = "hard";
    fpu = "vfpv3-d16";
    withTLS = true;
    libc = "glibc";
    platform = platforms.armv7l-hf-multiplatform;
    openssl.system = "linux-generic32";
    inherit (platform) gcc;
  };

  aarch64-multiplatform = rec {
    config = "aarch64-unknown-linux-gnu";
    bigEndian = false;
    arch = "aarch64";
    withTLS = true;
    libc = "glibc";
    platform = platforms.aarch64-multiplatform;
    inherit (platform) gcc;
  };
}
