{ stdenv, fetchFromGitHub, hugo, lib }: stdenv.mkDerivation rec {
  name = "kat-hugosite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "hugosite";
    rev = "2dc44e1668d38bb706b2290387a936c26d0dd50b";
    sha256 = "sha256-HuC8NebVfp7aXciFhaFbUin5g/ChH3g+zpRNJ/6qq7g=";
  };
  buildPhase = ''
    ${hugo}/bin/hugo
  '';
  installPhase = ''
    mkdir $out
    cp -r public/* $out
  '';
}
