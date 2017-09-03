#!/usr/bin/env bash
set -e

# install nix build dependencies
apt-get update && apt-get install -y \
  tmux build-essential openssl libssl-dev git flex bison automake autoconf \
  libsodium-dev pkg-config libgc-dev libsqlite3-dev libbz2-dev liblzma-dev \
  libcurl4-openssl-dev libseccomp-dev nlohmann-json-dev

# installer does not support aarch64, so compile nix from source
git clone https://github.com/NixOS/nix.git
$(cd nix && ./bootstrap.sh && ./configure --enable-gc --disable-doc-gen && make install -j96)

# create nixbld users
groupadd -r nixbld
for n in $(seq 1 10); do useradd -c "Nix build user $n" \
    -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
    nixbld$n; done

# nix is now ready to use
# optional- checkout local copy of nixpkgs for hacking
git clone https://github.com/NixOS/nixpkgs.git
$(cd nixpkgs && git remote add channels https://github.com/nixos/nixpkgs-channels \
  && git fetch --all \
  && git reset --hard channels/nixos-unstable)

export NIX_PATH=..:$NIX_PATH
export NIX_PATH=nixos-config=minimal.nix:$NIX_PATH
