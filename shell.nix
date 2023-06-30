{ nixpkgs ? import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {} }:
with nixpkgs;
let
  fontsConf = pkgs.makeFontsConf {
    fontDirectories = [ nixpkgs.libertinus ];
  };
in
  mkShell {
    buildInputs = [
      gnumake
      libertinus
      texlive.combined.scheme-full
      typst
      sile
      yq
      zola
      zsh
    ];
    FONTCONFIG_FILE = fontsConf;
  }
