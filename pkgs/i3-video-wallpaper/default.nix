{ lib
, stdenv
, fetchFromGitHub
, coreutils-full
, imagemagick
, xorg
, xwinwrap
, gnugrep
, xdotool
, mpv
, feh
, ps
, makeWrapper }:

stdenv.mkDerivation rec {
  name = "i3-video-wallpaper";

  src = fetchFromGitHub {
    owner = "Zolyn";
    repo = "i3-video-wallpaper";
    rev = "69b6e6e02929edc5ee2b93c5c4f7542a752385ea";
    hash = "sha256-A3+B8FOoPC8bbAcG2pmO07dVsTjtqVkJKAptSs0k9ns=";
  };

  buildInputs = [
    coreutils-full
    imagemagick
    xorg.xrandr
    xwinwrap
    gnugrep
    xdotool
    mpv
    feh
    ps
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp setup.sh $out/bin/i3-video-wallpaper
  '';

  postFixup = ''
    wrapProgram $out/bin/i3-video-wallpaper --set PATH ${lib.makeBinPath buildInputs}
  '';
}
