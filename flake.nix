{
  description = "Polytype: a rosetta stone for typesetting engines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    teracli.url = "github:chevdor/tera-cli";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      flake-compat,
      gitignore,
      teracli,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        fontsConf = pkgs.makeFontsConf {
          fontDirectories = [
            pkgs.gentium
            pkgs.libertinus
            pkgs.stix-two
            ".fonts"
          ];
        };
        inherit (gitignore.lib) gitignoreSource;
        polytype =
          rec {
          };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            cacert
            curl
            gentium
            ghostscript
            git
            gnumake
            groff
            groff.perl
            imagemagick
            libertinus
            nodejs
            satysfi
            sile
            stix-two
            teracli.defaultPackage.${system}
            texlive.combined.scheme-full
            typst
            python311Packages.weasyprint
            yq
            zola
            zsh
          ];
          FONTCONFIG_FILE = fontsConf;
          shellHook = ''
            make fonts
          '';
        };
      }
    );
}
