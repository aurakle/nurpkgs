{ pkgs }:

with pkgs; rec {
  # my programs/libraries
  dont-repeat-yourself = callPackage ./dont-repeat-yourself { };
  i3lock-blurred = callPackage ./i3lock-blurred { };
  easy-nixos = callPackage ./easy-nixos { };

  # programs/libraries by other people
  i3-video-wallpaper = callPackage ./i3-video-wallpaper { };

  # games
  bar = callPackage ./bar { };
  EternalModManager = callPackage ./EternalModManager { };
}
