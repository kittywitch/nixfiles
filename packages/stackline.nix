{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "stackline";
  version = "2022-11-29";

  src = fetchFromGitHub {
    owner = "AdamWagner";
    repo = "stackline";
    rev = "2aa0bd9a27f93bad24b0fd4da38f3c0356414098";
    sha256 = "sha256-x7SIgKR6rwkoVVbaAvjFr1N7wTF3atni/d6xGLBBRN4=";
  };

  installPhase = ''
    mkdir -p $out
    mv ./* $out/
  '';
}
