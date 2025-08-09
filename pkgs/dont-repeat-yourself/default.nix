{ lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, xorg
, libxkbcommon
, libGL
, xclip }:

let
  maintainer = "StellarWitch7";
  libs = [
    libxkbcommon
    libGL
  ] ++ (with xorg; [
    libX11
    libXcursor
    libxcb
    libXi
  ]);
in rustPlatform.buildRustPackage rec {
  pname = "dont-repeat-yourself";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = maintainer;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uLIg95Ilw/97+gg6KmrVWSmpb9eAAg8lZS2QAOp4E5I=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    xclip
  ] ++ libs;

  postFixup = ''
    wrapProgram $out/bin/${pname} --set LD_LIBRARY_PATH ${lib.makeLibraryPath libs}
  '';

  cargoLock = {
    lockFile = "${src}/Cargo.lock";

    outputHashes = {
      "x11-clipboard-0.9.3" = "sha256-FQEBzs1hl2oXr0qrUmN2C/AmM4bds4+97uXuaO5BvPc=";
    };
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/${maintainer}/${pname}";
    description = "Keyboard-only clipboard manager";
    license = licenses.mit;
    maintainers = [ maintainer ];
  };
}
