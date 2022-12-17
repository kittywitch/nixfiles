{ stdenv, fetchFromGitHub, lib }: stdenv.mkDerivation rec {
  name = "irlsite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "inskip.me";
    rev = "a430a42d70ca9ddb554e8e0c0ed78a33b3ccb9e5";
    sha256 = "sha256-SUhXD0/PdWkvMUGOVTm9PPw8fi+Q+7Psw61VhMKRf2I=";
  };
  buildPhase = ''
  '';
  installPhase = ''
    mkdir $out
    cp -r ./* $out
  '';
}
