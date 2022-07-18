{ stdenv, fetchFromGitHub, lib }: stdenv.mkDerivation rec {
  name = "irlsite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "inskip.me";
    rev = "696e282339dd5b958b45bc1597d31f53c2e6616b";
    sha256 = "sha256-EYtlGmfEjJ0n2F2OKgKD59SgvKHZC109jgRsyawqGNw=";
  };
  buildPhase = ''
  '';
  installPhase = ''
    mkdir $out
    cp -r ./* $out
  '';
}
