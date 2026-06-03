{ stdenv
, lib
, fetchFromGitHub
, home-manager }:

stdenv.mkDerivation rec {
  pname = "easy-nixos";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "aurakle";
    repo = "easy-nixos";
    rev = "v${version}";
    sha256 = "sha256-GDoYPGd+3f0FPuJK/2bWqyjTfUQ28mRQBYcEIf9yzig=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
    chmod -R +x $out/bin
    ln -s ${home-manager.out}/bin/home-manager $out/bin/home-manager
  '';

  runtimeDeps = [
    home-manager
  ];

  meta = with lib; {
    homepage = "https://github.com/aurakle/easy-nixos";
    description = "Wrapper and helper scripts to ease management of a NixOS system";
    license = licenses.mit;
  };
}
