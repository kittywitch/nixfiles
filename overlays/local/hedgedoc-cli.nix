{ lib, stdenv, makeWrapper, fetchFromGitHub, jq, curl, wget }:

stdenv.mkDerivation {
  pname = "hedgedoc-cli";
  version = "2021-05-17";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "cli";
    rev = "8b13b8836cf330921856907d905421d34a1e645c";
    sha256 = "1971v02jxlnxi09h0c6w3nzgq8w7b6ry09hjnvggypgxfjh53lhk";
  };

  paths = lib.makeBinPath [
    jq curl wget
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    install -Dm0755 bin/hedgedoc $out/bin/hdcli
    wrapProgram $out/bin/hdcli \
      --prefix PATH : "$paths"
  '';
}
