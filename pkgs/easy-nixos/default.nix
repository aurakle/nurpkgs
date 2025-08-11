{ stdenv
, lib
, fetchFromGitHub
, home-manager
, nano }:

stdenv.mkDerivation rec {
  pname = "easy-nixos";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "StellarWitch7";
    repo = "easy-nixos";
    rev = "v${version}";
    sha256 = "sha256-po0wcJ6FVHemAOysvbcEr37bIVV4jGxl6dLbc854eDI=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
    chmod -R +x $out/bin
    ln -s ${home-manager.out}/bin/home-manager $out/bin/home-manager
  '';

  runtimeDeps = [
    home-manager
    nano
  ];

  meta = with lib; {
    homepage = "https://github.com/StellarWitch7/easy-nixos";
    description = "Wrapper and helper scripts to ease management of a NixOS system";
    license = licenses.mit;
  };
}
