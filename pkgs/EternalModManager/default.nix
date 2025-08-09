{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, wrapGAppsHook
, glib
, gtk4
, openssl
, pango
, gdk-pixbuf
, graphene
, libadwaita }:

rustPlatform.buildRustPackage rec {
  pname = "EternalModManager";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "brunoanc";
    repo = "EternalModManager";
    rev = "v${version}";
    sha256 = "sha256-jNCubj3369+MyBW4H7pdIW4om2ejI0vBw/SA+ZO12k4=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gtk4
    openssl
    pango
    gdk-pixbuf
    graphene
    libadwaita
  ];

  cargoLock.lockFile = "${src}/Cargo.lock";
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/brunoanc/EternalModManager";
    description = "Mod manager for Doom Eternal";
    license = licenses.gpl3;
  };
}
