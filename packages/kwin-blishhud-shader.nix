{
  lib,
  stdenv,
  fetchFromGitHub,
  extra-cmake-modules,
  qt6,
  libepoxy,
  kwin,
}:
stdenv.mkDerivation rec {
  pname = "kwin-blishhud-shader";
  version = "1.0.0";

  dontWrapQtApps = true;
  src = fetchFromGitHub {
    owner = "FloFri";
    repo = pname;
    rev = "a7e4439a6450dc796bbfb99b64db788c592183eb";
    hash = "sha256-yCm57OCYTJpPY+OYpL/MlChhddccml3tH2jv/hgEAbo=";
  };

  nativeBuildInputs = [
    kwin
    qt6.full
    libepoxy
    extra-cmake-modules
  ];
}
