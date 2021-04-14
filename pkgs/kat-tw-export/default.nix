{ stdenv, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec { 
  pname = "kat-tw-export";
  version = "0.0.1";
  src = ./tw.pl; 
  buildInputs = [ perl perlPackages.JSON ];
  nativeBuildInputs = [ makeWrapper ];
  unpackPhase = "true";
  installPhase = ''
    install -Dm0755 $src $out/bin/kat-tw-export
    wrapProgram $out/bin/kat-tw-export --set PERL5LIB $PERL5LIB
  ''; 
}
