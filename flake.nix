{
  description = "mDNS Repeater";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "x86_64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            mdns-repeater = pkgs.stdenv.mkDerivation
              {
                pname = "mdns-repeater";
                version = "1.11-unstable-2023-12-16";
                src = ./.;

                buildPhase = ''
                  make all
                '';

                installPhase = ''
                  mkdir -p $out/bin
                  cp mdns-repeater/mdns-repeater.o $out/bin/mdns-repeater
                '';
              };
          });

      defaultPackage = forAllSystems (system: self.packages.${system}.mdns-repeater);
    };
}

