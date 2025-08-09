{ lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, xorg
, libxkbcommon
, libGL
, xclip }:

let
  owner = "aurakle";
  repo = "dont-repeat-yourself";
  version = "2.0.1";
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
  pname = repo;

  inherit version;

  src = fetchFromGitHub {
    inherit owner repo;

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
    wrapProgram $out/bin/${repo} --set LD_LIBRARY_PATH ${lib.makeLibraryPath libs}
  '';

  cargoHash = "sha256-quwdr71cuSQQ3tmLaZg2k/aoWLRaoqfGu0xj83mkGeI=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/${owner}/${repo}";
    description = "Keyboard-only clipboard manager";
    license = licenses.mit;
  };
}
