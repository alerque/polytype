{ nixpkgs ? import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {} }:
with nixpkgs;
mkShell {
  buildInputs = [
    gnumake
    texlive.combined.scheme-full
    typst
    sile
    zola
    zsh
  ];
}
