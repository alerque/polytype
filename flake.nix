{
  description = "Polytype: a rosetta stone for typesetting engines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    teracli.url = "github:chevdor/tera-cli/1cc2cdfb5f3a773926ef20a99a694253e2920e82";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
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
            cargo
            chromium
            clang
            curl
            gentium
            ghostscript
            git
            gnumake
            groff
            groff.perl
            imagemagick
            libertinus
            luajitPackages.luarocks
            mold
            netcat
            nodejs
            rustc
            satysfi
            sile
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
          '';
        };
      }
    );
}
