{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    clickrtraining.url = "github:enjarai/clickrtraining";
    clickrtraining.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fromInput = input: inputs.${input}.packages.${system}.default;
      in {
        packages = nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system};
        legacyPackages = {
          clickrtraining = fromInput "clickrtraining";
        } // (import ./default.nix { inherit pkgs; });
      }
    );
}
