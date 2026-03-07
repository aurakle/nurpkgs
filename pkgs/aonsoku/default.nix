{ lib
, fetchurl
, appimageTools
, makeDesktopItem }:

appimageTools.wrapType2 rec {
  pname = "aonsoku";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/victoralvesf/aonsoku/releases/download/v${version}/Aonsoku-v${version}-linux-x86_64.AppImage";
    hash = "sha256-6Z4pWtuIg4LEg22JTLRby6f4QmqFmEQ92G/WwbeGIAY=";
  };

  extraInstallCommands = let
    desktop = makeDesktopItem {
      desktopName = "Aonsoku";
      # icon = fetchurl {
      #   url = "";
      #   hash = "";
      # };

      name = pname;
      exec = pname;

      terminal = false;
    };
  in ''
    mkdir -p $out/share/applications
    cp ${desktop}/share/applications/${pname}.desktop $out/share/applications/
  '';

  extraPkgs = pkgs: [
  ];

  meta = with lib; {
    homepage = "https://github.com/victoralvesf/aonsoku";
    description = "Navidrome/Subsonic frontend";
    license = licenses.mit;
  };
}
