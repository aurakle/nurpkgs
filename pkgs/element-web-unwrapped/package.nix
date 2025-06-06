{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  jq,
  yarn,
  fixup-yarn-lock,
  nodejs,
  jitsi-meet,
}:

let
  pinData = import ./element-web-pin.nix;
  inherit (pinData.hashes) webSrcHash webYarnHash;
  noPhoningHome = {
    disable_guests = true; # disable automatic guest account registration at matrix.org
  };
in
stdenv.mkDerivation (
  finalAttrs:
  builtins.removeAttrs pinData [ "hashes" ]
  // {
    pname = "element-web";

    src = fetchFromGitHub {
      owner = "StellarWitch7";
      repo = "element-web";
      rev = "v${finalAttrs.version}";
      hash = webSrcHash;
    };

    offlineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      sha256 = webYarnHash;
    };

    nativeBuildInputs = [
      yarn
      fixup-yarn-lock
      jq
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      export VERSION=${finalAttrs.version}
      yarn --offline build:res
      yarn --offline build:module_system
      yarn --offline build:bundle

      runHook postBuild
    '';

    configurePhase = ''
      runHook preConfigure

      export HOME=$PWD/tmp
      # with the update of openssl3, some key ciphers are not supported anymore
      # this flag will allow those codecs again as a workaround
      # see https://medium.com/the-node-js-collection/node-js-17-is-here-8dba1e14e382#5f07
      # and https://github.com/element-hq/element-web/issues/21043
      export NODE_OPTIONS=--openssl-legacy-provider
      mkdir -p $HOME

      fixup-yarn-lock yarn.lock
      yarn config --offline set yarn-offline-mirror $offlineCache
      yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall

      cp -R webapp $out
      tar --extract --to-stdout --file ${jitsi-meet.src} jitsi-meet/libs/external_api.min.js > $out/jitsi_external_api.min.js
      echo "${finalAttrs.version}" > "$out/version"
      jq -s '.[0] * $conf' "config.sample.json" --argjson "conf" '${builtins.toJSON noPhoningHome}' > "$out/config.json"

      runHook postInstall
    '';

    meta = {
      description = "Glossy Matrix collaboration client for the web";
      homepage = "https://element.io/";
      changelog = "https://github.com/StellarWitch7/element-web/blob/v${finalAttrs.version}/CHANGELOG.md";
      maintainers = lib.teams.matrix.members;
      license = lib.licenses.asl20;
      platforms = lib.platforms.all;
    };
  }
)
