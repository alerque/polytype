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
    teracli.url = "github:chevdor/tera-cli/1cc2cdfb5f3a773926ef20a99a694253e2920e82";
    glu = {
      url = "github:boxesandglue/glu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    speedata-publisher = {
      url = "github:speedata/publisher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      flake-compat,
      gitignore,
      teracli,
      ...
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
        glu = inputs.glu.packages.${system}.default;
        speedata-publisher = inputs.speedata-publisher.packages.${system}.default;
        polytype =
          rec {
          };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            cacert
            cargo
            chromium
            clang
            curl
            decasify
            fontconfig
            gentium
            ghostscript
            git
            glu
            gnumake
            groff
            groff.perl
            imagemagick
            libertinus
            luajitPackages.luarocks
            mold
            netcat
            nodejs
            puppeteer-cli
            quarkdown
            rustc
            satysfi
            sile
            speedata-publisher
            stix-two
            teracli.defaultPackage.${system}
            texliveFull
            typst
            python313Packages.weasyprint
            xdg-utils
            yq
            zola
            zsh
          ];
          FONTCONFIG_FILE = fontsConf;
          PUPPETEER_SKIP_DOWNLOAD = "1";
          shellHook = ''
            make fonts
            export PUPPETEER_EXECUTABLE_PATH=${pkgs.chromium}/bin/chromium
            export PUPPETEER_ARGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage"
            export QD_NPM_PREFIX=${pkgs.puppeteer-cli}/lib/node_modules/puppeteer-cli
          '';
        };
      }
    );
}
