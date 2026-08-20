{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    clickr.url = "git+https://codeberg.org/trans-fish/clickr.git";
    clickr.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fromInput = input: inputs.${input}.packages.${system}.default;
      in {
        packages = nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system};
        legacyPackages = {
          clickr = fromInput "clickr";
        } // (import ./default.nix { inherit pkgs; });
      }
    );
}
