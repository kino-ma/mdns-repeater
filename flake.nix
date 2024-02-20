{
  description = "mDNS Repeater";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      mdns-repeater = nixpkgs.stdenv.mkDeriviation {
        pname = "mdns-repeater";
        version = "1.11-unstable-2023-12-16";
        nativeBuildInputs = [ nixpkgs.autoreconfHook ];
      };
    in
    {
      packages = flake-utils.lib.eachDefaultSystem (system: {
        mdns-repeater = mdns-repeater;
      });

      defaultPackage = flake-utils.lib.eachDefaultSystem (system: self.packages.${system}.mdns-repeater);
    };
}
