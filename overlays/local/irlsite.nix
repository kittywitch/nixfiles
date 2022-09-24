{ stdenv, fetchFromGitHub, lib }: stdenv.mkDerivation rec {
  name = "irlsite";
  src = fetchFromGitHub {
    owner = "kittywitch";
    repo = "inskip.me";
    rev = "3789d9ae2b0135828a6d92e2e6846aec42a29d88";
    sha256 = "sha256-EYtlGmfEjJ0n2F2OKgKD59SgvKHZC109jgRsyawqGNw=";
  };
  buildPhase = ''
  '';
  installPhase = ''
    mkdir $out
    cp -r ./* $out
  '';
}
