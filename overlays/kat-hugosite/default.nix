{ stdenv, fetchFromGitHub, hugo, lib }: stdenv.mkDerivation rec {
  name = "kat-hugosite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "hugosite";
    rev = "20d0b6cfa15956d8f411104291f5e47995b433d8";
    sha256 = "sha256-su3ey8FwTYyR1XP/hqsnsfh21JmSYO16wLRNIJx3zKs=";
  };
  buildPhase = ''
    ${hugo}/bin/hugo
  '';
  installPhase = ''
    mkdir $out
    cp -r public/* $out
  '';
}
