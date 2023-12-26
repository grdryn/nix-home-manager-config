{ stdenv }:

stdenv.mkDerivation rec {
  name = "aws-bitwarden";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    cp aws-bitwarden.sh $out/bin
  '';
}
