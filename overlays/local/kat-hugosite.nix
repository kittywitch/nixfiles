{ stdenv, fetchFromGitHub, hugo, lib }: stdenv.mkDerivation rec {
  name = "kat-hugosite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "hugosite";
    rev = "ee2bdd87dd5f6a59234f7102dea8189d22048a4c";
    sha256 = "sha256-j/fRTm5GIXmtmsdOBF2ILyYFCN+j39Ul5/kB2OoDQt4=";
  };
  buildPhase = ''
    ${hugo}/bin/hugo
  '';
  installPhase = ''
    mkdir $out
    cp -r public/* $out
  '';
}
