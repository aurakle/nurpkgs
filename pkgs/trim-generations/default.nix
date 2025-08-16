{ writeShellApplication
, coreutils
, gnused
, nix }:

writeShellApplication {
  name = "trim-generations";
  text = (builtins.readFile ./trim-generations.sh);
  runtimeInputs = [
    nix
    coreutils
    gnused
  ];
}
