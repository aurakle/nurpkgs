{ inputs, pkgs }:

let
  fromInput = input: input.packages.${pkgs.stdenv.hostPlatform.system}.default;
in with pkgs; rec {
  # my programs/libraries
  dont-repeat-yourself = callPackage ./dont-repeat-yourself { };
  i3lock-blurred = callPackage ./i3lock-blurred { };

  # programs/libraries by other people
  i3-video-wallpaper = callPackage ./i3-video-wallpaper { };
  clickrtraining = fromInput inputs.clickrtraining;

  # games
  bar = callPackage ./bar { };
  EternalModManager = callPackage ./EternalModManager { };
}
