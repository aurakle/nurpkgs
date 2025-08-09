{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    dont-repeat-yourself.url = "github:aurakle/dont-repeat-yourself";
    dont-repeat-yourself.inputs.nixpkgs.follows = "nixpkgs";

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
          dont-repeat-yourself = fromInput "dont-repeat-yourself";
          clickrtraining = fromInput "clickrtraining";
        } // (import ./default.nix { inherit pkgs; });
      }
    );
}
