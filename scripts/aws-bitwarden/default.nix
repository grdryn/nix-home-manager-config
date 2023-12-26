{ stdenv, lib, makeWrapper, awscli2, bitwarden-cli, jq }:

stdenv.mkDerivation rec {
  name = "aws-bitwarden";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp aws-bitwarden.sh $out/bin

    # ensures versions of dependencies come from known locations
    wrapProgram $out/bin/aws-bitwarden.sh \
      --set PATH ${lib.makeBinPath [ awscli2 bitwarden-cli jq ]}
  '';
}
