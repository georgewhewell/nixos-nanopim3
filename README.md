# Building

```
nix-build '<nixpkgs/nixos>' \
  -A config.system.build.sdImage \
  -I nixpkgs=.. \
  -I nixos-config=minimal.nix \
  -I board=boards/nanopi-m3 \
  -o nanopi-m3-minimal.img \
  --option build-cores 96 -j 10
```
