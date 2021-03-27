{ fetchFromGitHub, makeWrapper, lib, stdenv, jp2a, imagemagick, curl, neofetch }:

stdenv.mkDerivation rec {
  pname = "nekofetch";
  version = "1.4";

  src = fetchFromGitHub {
    rev = "9382314f82d37c7039e097c7eb4cf5460168d49d";
    owner = "proprdev";
    repo = "nekofetch";
    sha256 = "03p1br1pn9j9nsdjg29rdznm5qh34p8dx0834rgmlc3pxlr910ng";
  };


  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''true'';

  installPhase = ''
    mkdir -p $out/bin
    cp $src/nekofetch $out/bin/
  '';

  nekoPath = lib.makeBinPath [ jp2a imagemagick curl neofetch ];

  preFixup = ''
    wrapProgram $out/bin/nekofetch --prefix PATH : $nekoPath
  '';

}
