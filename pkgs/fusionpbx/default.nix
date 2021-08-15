{
  lib,
  stdenv,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fusionpbx";
  version = "master";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "2b8d011321ee5f2ffba967e38fcc8c542f378502";
    sha256 = "0fsmf67hrddz6aqjrjjqxa72iw108z2skwhn9jb3p465xfq7a9ij";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';

  meta = with lib; {
    description = "A full-featured domain based multi-tenant PBX and voice switch for FreeSWITCH.";
    homepage = "https://www.fusionpbx.com/";
    license = with licenses; mpl11;
    maintainers = with maintainers; [ kittywitch ];
    platforms = with platforms; unix;
  };
}
